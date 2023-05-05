import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_ipify/dart_ipify.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_practice/utils/constants.dart';
import 'package:flutter_practice/utils/exceptions/exceptions.dart';
import 'package:speed_test_dart/classes/coordinate.dart';
import 'package:speed_test_dart/classes/server.dart';
import 'package:speed_test_dart/enums/file_size.dart';
import 'package:speed_test_dart/speed_test_dart.dart';

import 'network.dart';

class NetworkRepo {
  final _captiveStreamController = StreamController<int>.broadcast();
  final _speedTest = SpeedTestDart();

  Stream<int> get networkStatusStream => _captiveStreamController.stream;

  Future<bool> deleteNetwork(Network network) async {
    final statusParams = NETWORK_CONNECTION_STATUS_COMMAND.split(' ');
    final statusCommand = statusParams.removeAt(0);
    final statusResult = await Process.run(statusCommand, statusParams);

    final statusResultOut = statusResult.stdout.toString().trim();
    final lines = statusResultOut.split('\n');

    String? uuid;

    for (final line in lines) {
      final fields = line.split(':');
      if (fields[0] == network.ssid) {
        uuid = fields[1];
        break;
      }
    }

    if (uuid == null || uuid.isEmpty) {
      return false;
    }

    final params = NETWORK_FORGET_COMMAND.split(' ');
    final command = params.removeAt(0);
    params[2] = uuid;
    final result = await Process.run(command, params);

    final resultOut = result.stdout.toString().trim();
    final resultErr = result.stderr.toString().trim();

    return resultErr.isEmpty;
  }

  Future<Network?> connectToNetwork({
    required Network network,
    String? password,
  }) async {
    final params = NETWORK_CONNECT_COMMAND.split(' ');
    final command = params.removeAt(0);
    params[3] = network.ssid;

    if (network.security.isEmpty) {
      params.removeAt(params.length - 1);
      params.removeAt(params.length - 1);
    } else {
      if (password != null) {
        params[5] = password;
      } else {
        params[5] = '';
      }
    }
    final result = await Process.run(command, params);

    final resultOut = result.stdout.toString().trim();
    final resultErr = result.stderr.toString().trim();

    if (resultErr.isNotEmpty || resultOut.toLowerCase().contains('error')) {
      await deleteNetwork(network);
      throw NetworkConnectionException(resultErr);
    }

    final isConnected = await isConnectedToNetwork();

    if (isConnected) {
      return getConnectedNetwork();
    }

    return null;
  }

  Future<bool> isConnectedToNetwork() async {
    final params = NETWORK_IS_CONNECTED_COMMAND.split(' ');
    final command = params.removeAt(0);
    final result = await Process.run(command, params);

    final resultOut = result.stdout.toString().trim();
    final resultErr = result.stderr.toString().trim();

    return resultOut.isNotEmpty;
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

  Future<bool> isWifiEnabled() async {
    final params = NETWORK_CONTROL_COMMAND.split(' ');
    final command = params.removeAt(0);
    final result = await Process.run(command, params);

    final resultOut = result.stdout.toString().trim();
    final resultErr = result.stderr.toString().trim();

    return resultOut == 'enabled';
  }

  Future<bool> switchWifiEnabled({bool? disable}) async {
    bool isEnabled = disable ?? false;
    if (disable == null) {
      isEnabled = await isWifiEnabled();
    }
    final finalParam = isEnabled ? 'off' : 'on';

    final params = NETWORK_CONTROL_COMMAND.split(' ');
    final command = params.removeAt(0);
    params.add(finalParam);

    final result = await Process.run(command, params);

    final resultOut = result.stdout.toString().trim();
    final resultErr = result.stderr.toString().trim();

    return !isEnabled;
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

  Future<void> dispose() async {
    _captiveStreamController.close();
  }

  Future<List<Server>> _getServerList() async {
    final uri = Uri.parse(
        'https://www.speedtest.net/api/js/servers?engine=js&limit=10&https_functional=true');

    final response = await http.get(uri);

    final respJson = jsonDecode(response.body);
    final result = <Server>[];

    for (final entry in respJson) {
      print('entry: $entry');
      final server = Server(
        int.parse(entry['id']),
        entry['name'] as String,
        entry['country'] as String,
        entry['sponsor'] as String,
        entry['host'] as String,
        entry['url'] as String,
        double.parse(entry['lat']),
        double.parse(entry['lon']),
        (entry['distance'] as int).toDouble(),
        0,
        Coordinate(
          double.parse(entry['lat']),
          double.parse(entry['lon']),
        ),
      );
      result.add(server);
    }

    return result;
  }

  Future<List<Server>> getBestServers() async {
    final servers = await _getServerList();

    final serverList = await _speedTest
        .getBestServers(
          servers: servers,
        )
        .timeout(const Duration(minutes: 2));

    return serverList;
  }

  Future<double> testDownloadingSpeed(List<Server> servers) async {
    try {
      final downloadSpeed = await _speedTest.testDownloadSpeed(
        servers: servers,
        simultaneousDownloads: 5,
        retryCount: 2,
        downloadSizes: [
          FileSize.SIZE_3500,
        ],
      );

      return downloadSpeed;
    } on SocketException catch (e, stack) {
      return 0;
    } on TimeoutException catch (e, stack) {
      return 0;
    }
  }

  Future<double> testUploadingSpeed(List<Server> servers) async {
    try {
      final uploadSpeed = await _speedTest.testUploadSpeed(
        servers: servers,
        simultaneousUploads: 5,
        retryCount: 2,
      );

      return uploadSpeed;
    } on SocketException catch (e, stack) {
      return 0;
    } on TimeoutException catch (e, stack) {
      return 0;
    }
  }

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('protohologram.com');

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on Object {
      return false;
    }
  }

  Future<Iterable<Network>> savedNetworks() async {
    final statusParams = NETWORK_CONNECTION_STATUS_COMMAND.split(' ');
    final statusCommand = statusParams.removeAt(0);
    final statusResult = await Process.run(statusCommand, statusParams);

    final statusResultOut = statusResult.stdout.toString().trim();
    final lines = statusResultOut.split('\n');

    final savedNetworks = <Network>[];

    for (final line in lines) {
      final fields = line.split(':');
      if (fields.last.toLowerCase().contains('wireless')) {
        final network = Network(
          ssid: fields.first,
          security: '',
          device: 'device',
          frequency: 0,
          rate: 0,
          signal: 0,
          autoConnect: fields[2] == 'yes',
        );
        savedNetworks.add(network);
      }
    }

    return savedNetworks;
  }

  Future<Network?> connectToSavedNetwork({required Network network}) async {
    final params = NETWORK_CONNECT_SAVED_COMMAND.split(' ');
    final command = params.removeAt(0);
    params.last = network.ssid;

    final result = await Process.run(command, params);

    final resultOut = result.stdout.toString().trim();
    final resultErr = result.stderr.toString().trim();

    if (resultErr.isNotEmpty || resultOut.toLowerCase().contains('error')) {
      await deleteNetwork(network);
      throw NetworkConnectionException(resultErr);
    }

    final isConnected = await isConnectedToNetwork();

    if (isConnected) {
      return getConnectedNetwork();
    }

    return null;
  }

  Future<void> toggleNetworkAutoConnect({required Network network}) async {
    try {
      final params = NETWORK_AUTOCONNECT_CHANGE_COMMAND.split(' ');
      final command = params.removeAt(0);
      params[2] = network.ssid;
      params.last = (!network.autoConnect).toString();

      final result = await Process.run(command, params);

      final resultOut = result.stdout.toString().trim();

      final resultErr = result.stderr.toString().trim();

      if (resultErr.isNotEmpty || resultOut.toLowerCase().contains('error')) {
        throw ToggleNetworkAutoConnectException(error: resultErr);
      }
    } on Exception catch (e, stack) {
      throw ToggleNetworkAutoConnectException(error: e.toString());
    }
  }

  Future<void> changeNetworkAutoConnectPriority({
    required Network network,
    int newPriority = 0,
  }) async {
    final params = NETWORK_AUTOCONNECT_PRIORITY_CHANGE_COMMAND.split(' ');
    final command = params.removeAt(0);
    params[2] = network.ssid;
    params.last = newPriority.toString();

    final result = await Process.run(command, params);

    final resultOut = result.stdout.toString().trim();

    final resultErr = result.stderr.toString().trim();

    if (resultErr.isNotEmpty || resultOut.toLowerCase().contains('error')) {
      throw ToggleNetworkAutoConnectException(error: resultErr);
    }
  }
}
