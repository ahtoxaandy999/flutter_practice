import 'package:freezed_annotation/freezed_annotation.dart';

part 'network.freezed.dart';

@freezed
class Network with _$Network {
  const Network._();

  const factory Network({
    required String ssid,
    required String security,
    required String device,
    required double frequency,
    required int rate,
    required int signal,
    @Default(false) bool isSelected,
    @Default(true) bool autoConnect,
    String? wanIPAddress,
    String? lanIPAddress,
  }) = _Network;

  @visibleForTesting
  factory Network.test() => const Network(
        ssid: 'test',
        security: 'test',
        device: 'test',
        frequency: 0,
        rate: 0,
        signal: 0,
      );
}
