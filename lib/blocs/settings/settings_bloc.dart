import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/data/repositories/ip_settings_repository.dart';
import 'package:flutter_practice/domain/core/failures.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';
import 'package:flutter_practice/domain/usecases/save_ip_settings_usecase.dart';
import 'package:flutter_practice/blocs/settings/settings_state.dart';
import 'package:flutter_practice/blocs/settings/settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SaveIpSettingsUseCase _saveIpSettingsUseCase;
  final IpSettingsRepository _ipSettingsRepository;

  SettingsBloc({
    required SaveIpSettingsUseCase saveIpSettingsUseCase,
    required IpSettingsRepository ipSettingsRepository,
  })  : _saveIpSettingsUseCase = saveIpSettingsUseCase,
        _ipSettingsRepository = ipSettingsRepository,
        super(SettingsState.initial()) {
    on<LoadIpSettings>(_onLoadIpSettings);
    on<SaveIpSettings>(_onSaveIpSettings);
  }

  Future<void> _onLoadIpSettings(
    LoadIpSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final IpSettings settings = await _ipSettingsRepository.loadIpSettings();
    emit(state.copyWith(ipSettings: settings));
  }

  Future<void> _onSaveIpSettings(
    SaveIpSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final IpSettings settings = event.settings;

    emit(state.copyWith(
      isSubmitting: true,
      saveFailureOrSuccessOption: none(),
    ));

    final Either<ServerError, Unit> failureOrSuccess =
        await _saveIpSettingsUseCase.execute(settings);

    if (failureOrSuccess.isRight()) {
      await _ipSettingsRepository.saveIpSettings(event.settings);
    }

    emit(failureOrSuccess.fold(
      (failure) => state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        saveFailureOrSuccessOption: some(left(failure)),
      ),
      (_) => state.copyWith(
        isSubmitting: false,
        showErrorMessages: false,
        saveFailureOrSuccessOption: some(right(unit)),
      ),
    ));
  }
}
