import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';
import 'package:flutter_practice/blocs/settings/settings_bloc.dart';
import 'package:flutter_practice/blocs/settings/settings_event.dart';
import 'package:flutter_practice/blocs/settings/settings_state.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../../domain/core/failures.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _subnetMaskController = TextEditingController();
  final TextEditingController _routerIPController = TextEditingController();

  @override
  void dispose() {
    _ipAddressController.dispose();
    _subnetMaskController.dispose();
    _routerIPController.dispose();
    super.dispose();
  }

  bool validateSubnetMask(String subnetMask) {
    final octets = subnetMask.split('.');

    if (octets.length != 4) {
      return false;
    }

    for (final octet in octets) {
      final value = int.tryParse(octet);

      if (value == null ||
          !(value == 0 ||
              value == 128 ||
              value == 192 ||
              value == 224 ||
              value == 240 ||
              value == 248 ||
              value == 252 ||
              value == 255)) {
        return false;
      }

      if (value != 255) {
        final binary = value.toRadixString(2).padLeft(8, '0');

        if (binary.indexOf('0') < binary.lastIndexOf('1')) {
          return false;
        }
      }
    }

    return true;
  }

  void _showErrorDialog(Failure failure) {
    final errorMessage = failure.message.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            previous.ipSettings != current.ipSettings,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
              (failure) => _showErrorDialog(failure),
              (_) => Navigator.pop(context),
            ),
          );
        },
        builder: (context, state) {
          _ipAddressController.text = state.ipSettings.ipAddress;
          _subnetMaskController.text = state.ipSettings.subnetMask;
          _routerIPController.text = state.ipSettings.routerIp;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _ipAddressController,
                    decoration: const InputDecoration(
                      labelText: 'IP Address',
                    ),
                    validator: (value) {
                      if (value == null || !validator.ip(value)) {
                        return 'Please enter a valid IP';
                      } else if (value == state.ipSettings.ipAddress) {
                        return 'Please enter a different IP';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _subnetMaskController,
                    decoration: const InputDecoration(
                      labelText: 'Subnet Mask',
                    ),
                    validator: (value) {
                      if (value == null || !validateSubnetMask(value)) {
                        return 'Please enter a valid Mask';
                      } else if (value == state.ipSettings.subnetMask) {
                        return 'Please enter a different Mask';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _routerIPController,
                    decoration: const InputDecoration(
                      labelText: 'Router IP',
                    ),
                    validator: (value) => value == null || !validator.ip(value)
                        ? 'Please enter a valid IP'
                        : null,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final IpSettings ipSettings = IpSettings(
                          ipAddress: _ipAddressController.text,
                          subnetMask: _subnetMaskController.text,
                          routerIp: _routerIPController.text,
                        );
                        context.read<SettingsBloc>().add(
                              SaveIpSettings(ipSettings),
                            );
                      }
                    },
                    child: state.isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
