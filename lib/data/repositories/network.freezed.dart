// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Network {
  String get ssid => throw _privateConstructorUsedError;
  String get security => throw _privateConstructorUsedError;
  String get device => throw _privateConstructorUsedError;
  double get frequency => throw _privateConstructorUsedError;
  int get rate => throw _privateConstructorUsedError;
  int get signal => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  bool get autoConnect => throw _privateConstructorUsedError;
  String? get wanIPAddress => throw _privateConstructorUsedError;
  String? get lanIPAddress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NetworkCopyWith<Network> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkCopyWith<$Res> {
  factory $NetworkCopyWith(Network value, $Res Function(Network) then) =
      _$NetworkCopyWithImpl<$Res, Network>;
  @useResult
  $Res call(
      {String ssid,
      String security,
      String device,
      double frequency,
      int rate,
      int signal,
      bool isSelected,
      bool autoConnect,
      String? wanIPAddress,
      String? lanIPAddress});
}

/// @nodoc
class _$NetworkCopyWithImpl<$Res, $Val extends Network>
    implements $NetworkCopyWith<$Res> {
  _$NetworkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ssid = null,
    Object? security = null,
    Object? device = null,
    Object? frequency = null,
    Object? rate = null,
    Object? signal = null,
    Object? isSelected = null,
    Object? autoConnect = null,
    Object? wanIPAddress = freezed,
    Object? lanIPAddress = freezed,
  }) {
    return _then(_value.copyWith(
      ssid: null == ssid
          ? _value.ssid
          : ssid // ignore: cast_nullable_to_non_nullable
              as String,
      security: null == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as double,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int,
      signal: null == signal
          ? _value.signal
          : signal // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      autoConnect: null == autoConnect
          ? _value.autoConnect
          : autoConnect // ignore: cast_nullable_to_non_nullable
              as bool,
      wanIPAddress: freezed == wanIPAddress
          ? _value.wanIPAddress
          : wanIPAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      lanIPAddress: freezed == lanIPAddress
          ? _value.lanIPAddress
          : lanIPAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NetworkCopyWith<$Res> implements $NetworkCopyWith<$Res> {
  factory _$$_NetworkCopyWith(
          _$_Network value, $Res Function(_$_Network) then) =
      __$$_NetworkCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ssid,
      String security,
      String device,
      double frequency,
      int rate,
      int signal,
      bool isSelected,
      bool autoConnect,
      String? wanIPAddress,
      String? lanIPAddress});
}

/// @nodoc
class __$$_NetworkCopyWithImpl<$Res>
    extends _$NetworkCopyWithImpl<$Res, _$_Network>
    implements _$$_NetworkCopyWith<$Res> {
  __$$_NetworkCopyWithImpl(_$_Network _value, $Res Function(_$_Network) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ssid = null,
    Object? security = null,
    Object? device = null,
    Object? frequency = null,
    Object? rate = null,
    Object? signal = null,
    Object? isSelected = null,
    Object? autoConnect = null,
    Object? wanIPAddress = freezed,
    Object? lanIPAddress = freezed,
  }) {
    return _then(_$_Network(
      ssid: null == ssid
          ? _value.ssid
          : ssid // ignore: cast_nullable_to_non_nullable
              as String,
      security: null == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as double,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int,
      signal: null == signal
          ? _value.signal
          : signal // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      autoConnect: null == autoConnect
          ? _value.autoConnect
          : autoConnect // ignore: cast_nullable_to_non_nullable
              as bool,
      wanIPAddress: freezed == wanIPAddress
          ? _value.wanIPAddress
          : wanIPAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      lanIPAddress: freezed == lanIPAddress
          ? _value.lanIPAddress
          : lanIPAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_Network extends _Network {
  const _$_Network(
      {required this.ssid,
      required this.security,
      required this.device,
      required this.frequency,
      required this.rate,
      required this.signal,
      this.isSelected = false,
      this.autoConnect = true,
      this.wanIPAddress,
      this.lanIPAddress})
      : super._();

  @override
  final String ssid;
  @override
  final String security;
  @override
  final String device;
  @override
  final double frequency;
  @override
  final int rate;
  @override
  final int signal;
  @override
  @JsonKey()
  final bool isSelected;
  @override
  @JsonKey()
  final bool autoConnect;
  @override
  final String? wanIPAddress;
  @override
  final String? lanIPAddress;

  @override
  String toString() {
    return 'Network(ssid: $ssid, security: $security, device: $device, frequency: $frequency, rate: $rate, signal: $signal, isSelected: $isSelected, autoConnect: $autoConnect, wanIPAddress: $wanIPAddress, lanIPAddress: $lanIPAddress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Network &&
            (identical(other.ssid, ssid) || other.ssid == ssid) &&
            (identical(other.security, security) ||
                other.security == security) &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.signal, signal) || other.signal == signal) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.autoConnect, autoConnect) ||
                other.autoConnect == autoConnect) &&
            (identical(other.wanIPAddress, wanIPAddress) ||
                other.wanIPAddress == wanIPAddress) &&
            (identical(other.lanIPAddress, lanIPAddress) ||
                other.lanIPAddress == lanIPAddress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      ssid,
      security,
      device,
      frequency,
      rate,
      signal,
      isSelected,
      autoConnect,
      wanIPAddress,
      lanIPAddress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NetworkCopyWith<_$_Network> get copyWith =>
      __$$_NetworkCopyWithImpl<_$_Network>(this, _$identity);
}

abstract class _Network extends Network {
  const factory _Network(
      {required final String ssid,
      required final String security,
      required final String device,
      required final double frequency,
      required final int rate,
      required final int signal,
      final bool isSelected,
      final bool autoConnect,
      final String? wanIPAddress,
      final String? lanIPAddress}) = _$_Network;
  const _Network._() : super._();

  @override
  String get ssid;
  @override
  String get security;
  @override
  String get device;
  @override
  double get frequency;
  @override
  int get rate;
  @override
  int get signal;
  @override
  bool get isSelected;
  @override
  bool get autoConnect;
  @override
  String? get wanIPAddress;
  @override
  String? get lanIPAddress;
  @override
  @JsonKey(ignore: true)
  _$$_NetworkCopyWith<_$_Network> get copyWith =>
      throw _privateConstructorUsedError;
}
