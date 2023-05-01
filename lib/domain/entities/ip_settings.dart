import 'package:equatable/equatable.dart';

class IpSettings extends Equatable {
  final String ipAddress;
  final String subnetMask;
  final String router;

  const IpSettings({
    required this.ipAddress,
    required this.subnetMask,
    required this.router,
  });

  IpSettings copyWith({
    String? ipAddress,
    String? subnetMask,
    String? router,
  }) {
    return IpSettings(
      ipAddress: ipAddress ?? this.ipAddress,
      subnetMask: subnetMask ?? this.subnetMask,
      router: router ?? this.router,
    );
  }

  @override
  List<Object?> get props => [ipAddress, subnetMask, router];

  @override
  bool get stringify => true;
}

