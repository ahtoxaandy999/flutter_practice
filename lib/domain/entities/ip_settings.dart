import 'package:equatable/equatable.dart';

class IpSettings extends Equatable {
  final String ipAddress;
  final String subnetMask;

  const IpSettings({
    required this.ipAddress,
    required this.subnetMask,
  });

  IpSettings copyWith({
    String? ipAddress,
    String? subnetMask,
  }) {
    return IpSettings(
      ipAddress: ipAddress ?? this.ipAddress,
      subnetMask: subnetMask ?? this.subnetMask,
    );
  }

  @override
  List<Object?> get props => [ipAddress, subnetMask];

  @override
  bool get stringify => true;
}
