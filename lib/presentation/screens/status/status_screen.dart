import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/settings/settings_bloc.dart';
import 'package:flutter_practice/blocs/settings/settings_event.dart';
import 'package:flutter_practice/blocs/settings/settings_state.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/network_status';
  const StatusScreen({super.key});

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.isManual != current.isManual,
                builder: (context, state) => ToggleButtons(
                  direction: Axis.vertical,
                  isSelected: state.isManual ? [true, false] : [false, true],
                  onPressed: (index) {
                    if (index == 0) {
                      context.read<SettingsBloc>().add(SetDHCP());
                    } else if (index == 1) {
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                  children: const [
                    SizedBox(
                      width: 200,
                      child: Text(
                        'DHCP',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        'Manual',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.ipSettings.ipAddress !=
                    current.ipSettings.ipAddress,
                builder: (context, state) {
                  final ipAddress = state.ipSettings.ipAddress;

                  return Text('IP Address: $ipAddress');
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.ipSettings.subnetMask !=
                    current.ipSettings.subnetMask,
                builder: (context, state) {
                  final subnetMask = state.ipSettings.subnetMask;

                  return Text('Subnet Mask: $subnetMask');
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.ipSettings.routerIp != current.ipSettings.routerIp,
                builder: (context, state) {
                  final routerIp = state.ipSettings.routerIp;

                  return Text('Router IP: $routerIp');
                },
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.isSubmitting != current.isSubmitting,
                builder: (context, state) {
                  return Visibility(
                    visible: state.isSubmitting,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
