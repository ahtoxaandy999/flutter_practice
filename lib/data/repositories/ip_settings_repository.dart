import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/ip_settings.dart';

class IpSettingsRepository {
  static const _ipKey = 'ip';
  static const _subnetMaskKey = 'subnetMask';
  static const _routerKey = 'router';

  final SharedPreferences _sharedPreferences;

  IpSettingsRepository(this._sharedPreferences);

  Future<IpSettings> loadIpSettings() async {
    final String? ipAddress = _sharedPreferences.getString('ip_address');
    final String? subnetMask = _sharedPreferences.getString('subnet_mask');
    final String? router = _sharedPreferences.getString('router');
    final IpSettings settings = IpSettings(ipAddress: ipAddress ?? '', subnetMask: subnetMask ?? '', router: router ?? '');
    return settings;
  }

  Future<void> saveIpSettings(IpSettings settings) async {
    await _sharedPreferences.setString(_ipKey, settings.ipAddress);
    await _sharedPreferences.setString(_subnetMaskKey, settings.subnetMask);
    await _sharedPreferences.setString(_routerKey, settings.router);
  }

  Future<IpSettings?> getIpSettings() async {
    final ip = _sharedPreferences.getString(_ipKey);
    final subnetMask = _sharedPreferences.getString(_subnetMaskKey);
    final router = _sharedPreferences.getString(_routerKey);
    if (ip == null || subnetMask == null) {
      return null;
    }
    return IpSettings(ipAddress: ip, subnetMask: subnetMask, router: router ?? '');
  }
}
