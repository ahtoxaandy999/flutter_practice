import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError({required String message}) = ServerError;
  const factory Failure.networkError() = NetworkError;
  const factory Failure.serverException({required String message}) =
      ServerException;

  String get message {
    return when(
      serverError: (message) => message,
      networkError: () => 'Network Error',
      serverException: (message) => message,
    );
  }

  const Failure._();
}
