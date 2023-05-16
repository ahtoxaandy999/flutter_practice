import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/ip_settings.dart';
import '../../utils/constants.dart';
import 'network.dart';

class IpSettingsRepository {
  static const _ipKey = 'ip';
  static const _subnetMaskKey = 'subnetMask';

  final SharedPreferences _sharedPreferences;

  IpSettingsRepository(this._sharedPreferences);

  Future<IpSettings> loadIpSettings() async {
    final String? ipAddress = _sharedPreferences.getString('ip_address');
    final String? subnetMask = _sharedPreferences.getString('subnet_mask');
    final IpSettings settings =
        IpSettings(ipAddress: ipAddress ?? '', subnetMask: subnetMask ?? '');
    return settings;
  }

  Future<void> saveIpSettings(IpSettings settings) async {
    await _sharedPreferences.setString(_ipKey, settings.ipAddress);
    await _sharedPreferences.setString(_subnetMaskKey, settings.subnetMask);
  }

  Future<IpSettings?> getIpSettings() async {
    final ip = _sharedPreferences.getString(_ipKey);
    final subnetMask = _sharedPreferences.getString(_subnetMaskKey);
    if (ip == null || subnetMask == null) {
      return null;
    }
    return IpSettings(ipAddress: ip, subnetMask: subnetMask);
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

  Future<void> updateIpAndMask(String ipAddress, String subnetMask) async {
    final process = await Process.start('ifconfig',
        ['wlx7cc2c62ce171', 'inet', ipAddress, 'netmask', subnetMask]);
    final output = await process.stdout.transform(utf8.decoder).toList();
    final errorOutput = await process.stderr.transform(utf8.decoder).toList();

    if (await process.exitCode != 0) {
      throw Exception(
          'Failed to update IP address and mask. Error output: $errorOutput');
    }
  }
}
