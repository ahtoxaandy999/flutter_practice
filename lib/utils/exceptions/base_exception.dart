abstract class BaseException implements Exception {
  final String error;

  const BaseException(this.error);

  @override
  String toString() => error;
}
