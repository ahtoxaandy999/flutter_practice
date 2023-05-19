import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/settings/settings_bloc.dart';
import 'package:flutter_practice/blocs/settings/settings_event.dart';
import 'package:flutter_practice/blocs/settings/settings_state.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/network_status';

  const StatusScreen({Key? key}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context).add(GetIpSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsState) {
            final ipAddress = state.ipSettings.ipAddress;
            final subnetMask = state.ipSettings.subnetMask;

            return Padding(
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
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
