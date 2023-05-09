import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';
import 'package:flutter_practice/domain/core/failures.dart';
import 'package:dartz/dartz.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required IpSettings ipSettings,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> saveFailureOrSuccessOption,
  }) = _SettingsState;

  factory SettingsState.initial() => SettingsState(
        ipSettings: const IpSettings(
          ipAddress: '',
          subnetMask: '',
        ),
        showErrorMessages: false,
        isSubmitting: false,
        saveFailureOrSuccessOption: none(),
      );
}
