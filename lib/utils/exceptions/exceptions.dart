class NetworkConnectionException implements Exception {
  final String error;

  const NetworkConnectionException(this.error);

  @override
  String toString() => error;
}

class WifiMacException implements Exception {
  final String error;

  const WifiMacException(this.error);

  @override
  String toString() => error;
}

class HardwareDeviceException implements Exception {
  final String error;

  const HardwareDeviceException(this.error);

  @override
  String toString() => error;
}

class PlayerIndexException implements Exception {}

class WebviewException implements Exception {
  final String error;

  const WebviewException(this.error);

  @override
  String toString() => error;
}

class ToggleNetworkAutoConnectException implements Exception {
  final String? error;

  const ToggleNetworkAutoConnectException({this.error});

  @override
  String toString() => error ?? 'Toggle network autoconnect exception';
}

class NetworkAutoConnectPriorityChangeException implements Exception {
  final String? error;

  const NetworkAutoConnectPriorityChangeException({this.error});

  @override
  String toString() =>
      error ?? 'Change network autoconnect priority cahnge exception';
}
