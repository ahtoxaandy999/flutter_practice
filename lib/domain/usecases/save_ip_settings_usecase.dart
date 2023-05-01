import 'package:dartz/dartz.dart';
import 'package:flutter_practice/data/repositories/ip_settings_repository.dart';
import 'package:flutter_practice/domain/core/failures.dart';
import 'package:flutter_practice/domain/entities/ip_settings.dart';

class SaveIpSettingsUseCase {
  final IpSettingsRepository repository;

  SaveIpSettingsUseCase({required this.repository});

  Future<Either<ServerError, Unit>> execute(IpSettings settings) async {
    try {
      await repository.saveIpSettings(settings);
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerError(e.message));
    }
  }
}
