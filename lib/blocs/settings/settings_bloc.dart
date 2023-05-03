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
        super(SettingsState.initial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    yield* event.map(
      loadIpSettings: (e) async* {
        final IpSettings settings = await _ipSettingsRepository.loadIpSettings();
        yield state.copyWith(
          ipSettings: settings,
        );
      },
      saveIpSettings: (e) async* {
        yield state.copyWith(
          isSubmitting: true,
          saveFailureOrSuccessOption: none(),
        );
        final Either<ServerError, Unit> failureOrSuccess =
            await _saveIpSettingsUseCase.execute(e.settings);
        yield failureOrSuccess.fold(
          (failure) => state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            saveFailureOrSuccessOption: some(left(failure)),
          ),
          (_) => state.copyWith(
            isSubmitting: false,
            saveFailureOrSuccessOption: some(right(unit)),
          ),
        );
      },
      ipSettingsSnackBarClosed: (e) async* {
        yield state.copyWith(
          saveFailureOrSuccessOption: none(),
        );
      },
    );
  }
}
