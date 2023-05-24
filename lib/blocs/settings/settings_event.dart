import 'package:equatable/equatable.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';
import 'package:flutter_practice/blocs/settings/settings_state.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];

  Stream<SettingsState> mapToState(
      {required Stream<IpSettings> Function() loadIpSettings,
      required Stream<SettingsState> Function(IpSettings) saveIpSettings,
      required Stream<SettingsState> Function()
          ipSettingsSnackBarClosed}) async* {}
}

class GetIpSettings extends SettingsEvent {}

class SaveIpSettings extends SettingsEvent {
  final IpSettings settings;

  const SaveIpSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}

class IpChanged extends SettingsEvent {
  final String ipAddress;

  const IpChanged({required this.ipAddress});

  @override
  List<Object?> get props => [ipAddress];
}

class MaskChanged extends SettingsEvent {
  final String subnetMask;

  const MaskChanged({required this.subnetMask});

  @override
  List<Object?> get props => [subnetMask];
}

class SetDHCP extends SettingsEvent {}
