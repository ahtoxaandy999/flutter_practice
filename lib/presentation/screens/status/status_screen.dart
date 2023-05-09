import 'dart:io';

import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/network_status';

  const StatusScreen({super.key});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String ipAddress = '';
  String subnetMask = '';

  @override
  void initState() {
    super.initState();
    _getNetworkStatus();
  }

  Future<void> _getNetworkStatus() async {
    try {
      final result = await Process.run('ifconfig', []);
      final output = result.stdout as String;
      final regex = RegExp(
          r'inet (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}).*mask\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})');
      final match = regex.firstMatch(output);
      setState(() {
        ipAddress = match?.group(1) ?? '';
        subnetMask = match?.group(2) ?? '';
      });
    } on ProcessException catch (e) {
      print('Error getting network status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('IP Address:'),
            Text(ipAddress),
            const SizedBox(height: 16),
            const Text('Subnet Mask:'),
            Text(subnetMask),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('Manual'),
            ),
          ],
        ),
      ),
    );
  }
}
