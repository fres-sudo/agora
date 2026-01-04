// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pos_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PosSettings {

 String get currencySymbol; double get taxRate;// e.g., 0.08 for 8%
 String? get receiptHeader; String? get printerIp; bool get showImages;
/// Create a copy of PosSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosSettingsCopyWith<PosSettings> get copyWith => _$PosSettingsCopyWithImpl<PosSettings>(this as PosSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosSettings&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.receiptHeader, receiptHeader) || other.receiptHeader == receiptHeader)&&(identical(other.printerIp, printerIp) || other.printerIp == printerIp)&&(identical(other.showImages, showImages) || other.showImages == showImages));
}


@override
int get hashCode => Object.hash(runtimeType,currencySymbol,taxRate,receiptHeader,printerIp,showImages);

@override
String toString() {
  return 'PosSettings(currencySymbol: $currencySymbol, taxRate: $taxRate, receiptHeader: $receiptHeader, printerIp: $printerIp, showImages: $showImages)';
}


}

/// @nodoc
abstract mixin class $PosSettingsCopyWith<$Res>  {
  factory $PosSettingsCopyWith(PosSettings value, $Res Function(PosSettings) _then) = _$PosSettingsCopyWithImpl;
@useResult
$Res call({
 String currencySymbol, double taxRate, String? receiptHeader, String? printerIp, bool showImages
});




}
/// @nodoc
class _$PosSettingsCopyWithImpl<$Res>
    implements $PosSettingsCopyWith<$Res> {
  _$PosSettingsCopyWithImpl(this._self, this._then);

  final PosSettings _self;
  final $Res Function(PosSettings) _then;

/// Create a copy of PosSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currencySymbol = null,Object? taxRate = null,Object? receiptHeader = freezed,Object? printerIp = freezed,Object? showImages = null,}) {
  return _then(_self.copyWith(
currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,receiptHeader: freezed == receiptHeader ? _self.receiptHeader : receiptHeader // ignore: cast_nullable_to_non_nullable
as String?,printerIp: freezed == printerIp ? _self.printerIp : printerIp // ignore: cast_nullable_to_non_nullable
as String?,showImages: null == showImages ? _self.showImages : showImages // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PosSettings].
extension PosSettingsPatterns on PosSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosSettings value)  $default,){
final _that = this;
switch (_that) {
case _PosSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PosSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currencySymbol,  double taxRate,  String? receiptHeader,  String? printerIp,  bool showImages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosSettings() when $default != null:
return $default(_that.currencySymbol,_that.taxRate,_that.receiptHeader,_that.printerIp,_that.showImages);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currencySymbol,  double taxRate,  String? receiptHeader,  String? printerIp,  bool showImages)  $default,) {final _that = this;
switch (_that) {
case _PosSettings():
return $default(_that.currencySymbol,_that.taxRate,_that.receiptHeader,_that.printerIp,_that.showImages);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currencySymbol,  double taxRate,  String? receiptHeader,  String? printerIp,  bool showImages)?  $default,) {final _that = this;
switch (_that) {
case _PosSettings() when $default != null:
return $default(_that.currencySymbol,_that.taxRate,_that.receiptHeader,_that.printerIp,_that.showImages);case _:
  return null;

}
}

}

/// @nodoc


class _PosSettings extends PosSettings {
  const _PosSettings({required this.currencySymbol, required this.taxRate, required this.receiptHeader, required this.printerIp, required this.showImages}): super._();
  

@override final  String currencySymbol;
@override final  double taxRate;
// e.g., 0.08 for 8%
@override final  String? receiptHeader;
@override final  String? printerIp;
@override final  bool showImages;

/// Create a copy of PosSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosSettingsCopyWith<_PosSettings> get copyWith => __$PosSettingsCopyWithImpl<_PosSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosSettings&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.receiptHeader, receiptHeader) || other.receiptHeader == receiptHeader)&&(identical(other.printerIp, printerIp) || other.printerIp == printerIp)&&(identical(other.showImages, showImages) || other.showImages == showImages));
}


@override
int get hashCode => Object.hash(runtimeType,currencySymbol,taxRate,receiptHeader,printerIp,showImages);

@override
String toString() {
  return 'PosSettings(currencySymbol: $currencySymbol, taxRate: $taxRate, receiptHeader: $receiptHeader, printerIp: $printerIp, showImages: $showImages)';
}


}

/// @nodoc
abstract mixin class _$PosSettingsCopyWith<$Res> implements $PosSettingsCopyWith<$Res> {
  factory _$PosSettingsCopyWith(_PosSettings value, $Res Function(_PosSettings) _then) = __$PosSettingsCopyWithImpl;
@override @useResult
$Res call({
 String currencySymbol, double taxRate, String? receiptHeader, String? printerIp, bool showImages
});




}
/// @nodoc
class __$PosSettingsCopyWithImpl<$Res>
    implements _$PosSettingsCopyWith<$Res> {
  __$PosSettingsCopyWithImpl(this._self, this._then);

  final _PosSettings _self;
  final $Res Function(_PosSettings) _then;

/// Create a copy of PosSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currencySymbol = null,Object? taxRate = null,Object? receiptHeader = freezed,Object? printerIp = freezed,Object? showImages = null,}) {
  return _then(_PosSettings(
currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,receiptHeader: freezed == receiptHeader ? _self.receiptHeader : receiptHeader // ignore: cast_nullable_to_non_nullable
as String?,printerIp: freezed == printerIp ? _self.printerIp : printerIp // ignore: cast_nullable_to_non_nullable
as String?,showImages: null == showImages ? _self.showImages : showImages // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
