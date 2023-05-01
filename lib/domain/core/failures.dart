import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError(String message) = ServerError;
  const factory Failure.networkError() = NetworkError;
  const factory Failure.serverException(String message) = ServerException;

}
