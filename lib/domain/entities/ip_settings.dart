import 'package:equatable/equatable.dart';

class IpSettings extends Equatable {
  final String ipAddress;
  final String subnetMask;
  final String routerIp;

  const IpSettings({
    required this.ipAddress,
    required this.subnetMask,
    required this.routerIp,
  });

  IpSettings copyWith({
    String? ipAddress,
    String? subnetMask,
    String? routerIp,
  }) {
    return IpSettings(
      ipAddress: ipAddress ?? this.ipAddress,
      subnetMask: subnetMask ?? this.subnetMask,
      routerIp: routerIp ?? this.routerIp,
    );
  }

  @override
  List<Object?> get props => [ipAddress, subnetMask, routerIp];

  @override
  bool get stringify => true;
}
