import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';
import 'package:flutter_practice/blocs/settings/settings_bloc.dart';
import 'package:flutter_practice/blocs/settings/settings_event.dart';
import 'package:flutter_practice/blocs/settings/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _ipAddressController = TextEditingController();
  TextEditingController _subnetMaskController = TextEditingController();
  TextEditingController _routerController = TextEditingController();

  @override
  void dispose() {
    _ipAddressController.dispose();
    _subnetMaskController.dispose();
    _routerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
              (failure) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$failure')),
              ),
              (_) => Navigator.pop(context),
            ),
          );
        },
        builder: (context, state) {
          _ipAddressController.text = state.ipSettings.ipAddress;
          _subnetMaskController.text = state.ipSettings.subnetMask;
          _routerController.text = state.ipSettings.router;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _ipAddressController,
                    decoration: InputDecoration(
                      labelText: 'IP Address',
                    ),
                    validator: (_) =>
                        state.showErrorMessages && state.ipSettings.ipAddress.isEmpty
                            ? 'IP Address is required'
                            : null,
                    onChanged: (value) => context.read<SettingsBloc>().add(
                          SaveIpSettings(
                            state.ipSettings.copyWith(ipAddress: value),
                          ),
                        ),
                  ),
                  TextFormField(
                    controller: _subnetMaskController,
                    decoration: InputDecoration(
                      labelText: 'Subnet Mask',
                    ),
                    validator: (_) => state.showErrorMessages &&
                            state.ipSettings.subnetMask.isEmpty
                        ? 'Subnet Mask is required'
                        : null,
                    onChanged: (value) => context.read<SettingsBloc>().add(
                          SaveIpSettings(
                            state.ipSettings.copyWith(subnetMask: value),
                          ),
                        ),
                  ),
                  TextFormField(
                    controller: _routerController,
                    decoration: InputDecoration(
                      labelText: 'Router',
                    ),
                    validator: (_) =>
                        state.showErrorMessages && state.ipSettings.router.isEmpty
                            ? 'Router is required'
                            : null,
                    onChanged: (value) => context.read<SettingsBloc>().add(
                          SaveIpSettings(
                            state.ipSettings.copyWith(router: value),
                          ),
                        ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(
                            SaveIpSettings(state.ipSettings),
                          );
                    },
                    child: state.isSubmitting
                        ? CircularProgressIndicator()
                        : Text('Save'),
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
