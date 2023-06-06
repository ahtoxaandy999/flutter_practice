import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter_practice/utils/exceptions/logic_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/ip_settings.dart';
import '../../utils/constants.dart';
import 'network.dart';

class IpSettingsRepository {
  static const _ipKey = 'ip';
  static const _subnetMaskKey = 'subnetMask';

  final SharedPreferences _sharedPreferences;

  IpSettingsRepository(this._sharedPreferences);

  Future<IpSettings> getIpSettings() async {
    final device = await getWANDevice();
    final command = 'sudo ifconfig $device';
    final result = await Process.run('bash', ['-c', command]);
    final output = result.stdout as String;
    final regex = RegExp(
        r'inet (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}).*mask\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})');
    final match = regex.firstMatch(output);
    if (match != null) {
      final ipAddress = match.group(1);
      final subnetMask = match.group(2);
      final gateway = await getGateway();
      return IpSettings(
          ipAddress: ipAddress!, subnetMask: subnetMask!, routerIp: gateway);
    } else {
      throw const NetworkChangeIPException(
          'Failed to retrieve IP address and subnet mask');
    }
  }

  Future<String> getGateway() async {
    final device = await getWANDevice();
    final command = 'ip route show dev $device';
    final result = await Process.run('bash', ['-c', command]);
    final output = result.stdout as String;
    final lines = LineSplitter.split(output);
    for (var line in lines) {
      final parts = line.split(' ');
      if (parts.contains('default')) {
        final gatewayIndex = parts.indexOf('via');
        if (gatewayIndex != -1 && gatewayIndex < parts.length - 1) {
          return parts[gatewayIndex + 1];
        }
      }
    }
    throw Exception('Failed to retrieve gateway for device: $device');
  }

  Future<Network?> getConnectedNetwork() async {
    final networks = await scanNetworks();

    for (final network in networks) {
      if (network.isSelected) {
        final wanIp = await getWANIPAddress();
        final lanIp = await getLANIPAddress();

        return network.copyWith(
          wanIPAddress: wanIp,
          lanIPAddress: lanIp,
        );
      }
    }

    return null;
  }

  Future<Iterable<Network>> scanNetworks() async {
    final params = NETWORK_SCAN_COMMAND.split(' ');
    final command = params.removeAt(0);

    final result = await Process.run(command, params);
    final resultOut = result.stdout.toString().trim();
    final resultErr = result.stderr.toString().trim();

    final availableNetworks = <Network>[];
    final lines = resultOut.split('\n');

    for (final line in lines) {
      final fields = line.split(':');

      final frequency = double.tryParse(fields[2].split(' ')[0])! / 1000;
      final rate = int.tryParse(fields[3].split(' ')[0])!;

      final network = Network(
        ssid: fields[0],
        security: fields[1],
        frequency: frequency,
        rate: rate,
        signal: int.tryParse(fields[4])!,
        device: fields[5],
        isSelected: fields.last == '*',
      );

      final isNetworkExist = availableNetworks.firstWhereOrNull(
        (element) => element.ssid == network.ssid && !network.isSelected,
      );
      if (isNetworkExist == null) {
        availableNetworks.add(network);
      }
    }

    return availableNetworks;
  }

  Future<String?> getWANIPAddress() async {
    try {
      final ip = await Ipify.ipv4();

      return ip;
    } on Object catch (e, stack) {
      return null;
    }
  }

  Future<String?> getLANIPAddress() async {
    final params = NETWORK_GET_LOCAL_IPADDRESS_COMMAND.split(' ');
    final command = params.removeAt(0);

    try {
      final result = await Process.run(command, params);

      final resultOut = result.stdout.toString().trim().split(' ');
      return resultOut.first;
    } on Object catch (e, stack) {
      return null;
    }
  }

  Future<String?> getWANDevice() async {
    final networks = await scanNetworks();
    final selectedNetwork =
        networks.firstWhereOrNull((network) => network.isSelected);
    if (selectedNetwork != null) {
      final device = selectedNetwork.device;
      return device;
    } else {
      return null;
    }
  }

  Future<void> updateIpAndMask(
      String ipAddress, String subnetMask, String device) async {
    final command = 'sudo ifconfig $device inet $ipAddress netmask $subnetMask';
    try {
      final result = await Process.run('/bin/sh', ['-c', command]);
      final resultOut = result.stdout.toString().trim();
      final resultErr = result.stderr.toString().trim();
      print('updateIpAndMask $resultOut $resultErr');
    } on Object catch (e) {
      throw NetworkChangeIPException(
          'Failed to update IP address and mask. Error output: $e');
    }
  }

  Future<void> updateGateway(String routerIp, String device) async {
    final command = 'sudo ip route change default via $routerIp dev $device';
    try {
      final result = await Process.run('/bin/sh', ['-c', command]);
      final resultOut = result.stdout.toString().trim();
      final resultErr = result.stderr.toString().trim();
      print('updateGateway $resultOut $resultErr');
    } on Object catch (e) {
      throw NetworkChangeIPException(
          'Failed to update gateway. Error output: $e');
    }
  }

  Future<void> setDHCP() async {
    final device = await getWANDevice();
    final releaseCommand = 'sudo dhclient -r $device';
    final renewCommand = 'sudo dhclient $device';
    try {
      await Process.run('/bin/sh', ['-c', releaseCommand]);
      await Process.run('/bin/sh', ['-c', renewCommand]);
    } on Object catch (e) {
      throw NetworkChangeIPException('Failed to set DHCP. Error output: $e');
    }
  }

  Future<bool> isDHCP() async {
    final device = await getWANDevice();
    final command = 'ip addr show $device';
    try {
      final result = await Process.run('/bin/sh', ['-c', command]);
      final output = result.stdout as String;
      final lines = LineSplitter.split(output);

      for (final line in lines) {
        if (line.contains('inet ') && line.contains(' dynamic ')) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
