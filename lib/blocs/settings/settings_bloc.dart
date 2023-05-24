import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/data/repositories/ip_settings_repository.dart';
import 'package:flutter_practice/domain/core/failures.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';
import 'package:flutter_practice/blocs/settings/settings_state.dart';
import 'package:flutter_practice/blocs/settings/settings_event.dart';
import 'package:flutter_practice/utils/exceptions/logic_exception.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final IpSettingsRepository _ipSettingsRepository;

  SettingsBloc({
    required IpSettingsRepository ipSettingsRepository,
  })  : _ipSettingsRepository = ipSettingsRepository,
        super(SettingsState.initial()) {
    on<GetIpSettings>(_onGetIpSettings);
    on<SaveIpSettings>(_onSaveIpSettings);
    on<IpChanged>(_onIpChanged);
    on<MaskChanged>(_onMaskChanged);
    on<SetDHCP>(_onSetDHCP);
  }

  Future<void> _onMaskChanged(
    MaskChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final IpSettings settings = state.ipSettings.copyWith(
      subnetMask: event.subnetMask,
    );
    emit(state.copyWith(
      ipSettings: settings,
      saveFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _onIpChanged(
    IpChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final IpSettings settings = state.ipSettings.copyWith(
      ipAddress: event.ipAddress,
    );
    emit(state.copyWith(
      ipSettings: settings,
      saveFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _onGetIpSettings(
    GetIpSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final IpSettings settings = await _ipSettingsRepository.getIpSettings();
    emit(state.copyWith(ipSettings: settings));
  }

  Future<void> _onSaveIpSettings(
    SaveIpSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      final settings = state.ipSettings;
      await _ipSettingsRepository.updateIpAndMask(
          settings.ipAddress, settings.subnetMask);

      emit(state.copyWith(
        isSubmitting: false,
        saveFailureOrSuccessOption: some(right(unit)),
      ));
    } on NetworkChangeIPException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        saveFailureOrSuccessOption:
            some(left(ServerError(message: e.toString()))),
      ));
    } on Object {
      rethrow;
    }
  }

  Future<void> _onSetDHCP(
    SetDHCP event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      await _ipSettingsRepository.setDHCP();
      final IpSettings settings = await _ipSettingsRepository.getIpSettings();
      emit(state.copyWith(
        isSubmitting: false,
        ipSettings: settings,
        saveFailureOrSuccessOption: some(right(unit)),
      ));
    } on NetworkChangeIPException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        saveFailureOrSuccessOption:
            some(left(ServerError(message: e.toString()))),
      ));
    } on Object {
      rethrow;
    }
  }
}
