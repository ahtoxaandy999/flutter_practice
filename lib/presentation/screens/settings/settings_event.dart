import 'package:equatable/equatable.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';
import 'package:flutter_practice/presentation/screens/settings/settings_state.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];

  map({required Stream Function(dynamic e) loadIpSettings, required Stream<SettingsState> Function(dynamic e) saveIpSettings, required Stream<SettingsState> Function(dynamic e) ipSettingsSnackBarClosed}) {}
}

class LoadIpSettings extends SettingsEvent {}

class SaveIpSettings extends SettingsEvent {
  final IpSettings settings;

  const SaveIpSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}
