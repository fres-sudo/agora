// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clock_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClockRecord {

 int get id; int get employeeId; String get employeeName; DateTime get clockedInAt; DateTime? get clockedOutAt; String? get note;// Null means the cash count was skipped at clock-out, not that it
// balanced (docs/features/04-volunteer-shift-accountability.md).
 CashReconciliation? get reconciliation;
/// Create a copy of ClockRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClockRecordCopyWith<ClockRecord> get copyWith => _$ClockRecordCopyWithImpl<ClockRecord>(this as ClockRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClockRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.clockedInAt, clockedInAt) || other.clockedInAt == clockedInAt)&&(identical(other.clockedOutAt, clockedOutAt) || other.clockedOutAt == clockedOutAt)&&(identical(other.note, note) || other.note == note)&&(identical(other.reconciliation, reconciliation) || other.reconciliation == reconciliation));
}


@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,clockedInAt,clockedOutAt,note,reconciliation);

@override
String toString() {
  return 'ClockRecord(id: $id, employeeId: $employeeId, employeeName: $employeeName, clockedInAt: $clockedInAt, clockedOutAt: $clockedOutAt, note: $note, reconciliation: $reconciliation)';
}


}

/// @nodoc
abstract mixin class $ClockRecordCopyWith<$Res>  {
  factory $ClockRecordCopyWith(ClockRecord value, $Res Function(ClockRecord) _then) = _$ClockRecordCopyWithImpl;
@useResult
$Res call({
 int id, int employeeId, String employeeName, DateTime clockedInAt, DateTime? clockedOutAt, String? note, CashReconciliation? reconciliation
});


$CashReconciliationCopyWith<$Res>? get reconciliation;

}
/// @nodoc
class _$ClockRecordCopyWithImpl<$Res>
    implements $ClockRecordCopyWith<$Res> {
  _$ClockRecordCopyWithImpl(this._self, this._then);

  final ClockRecord _self;
  final $Res Function(ClockRecord) _then;

/// Create a copy of ClockRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? clockedInAt = null,Object? clockedOutAt = freezed,Object? note = freezed,Object? reconciliation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,clockedInAt: null == clockedInAt ? _self.clockedInAt : clockedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,clockedOutAt: freezed == clockedOutAt ? _self.clockedOutAt : clockedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,reconciliation: freezed == reconciliation ? _self.reconciliation : reconciliation // ignore: cast_nullable_to_non_nullable
as CashReconciliation?,
  ));
}
/// Create a copy of ClockRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashReconciliationCopyWith<$Res>? get reconciliation {
    if (_self.reconciliation == null) {
    return null;
  }

  return $CashReconciliationCopyWith<$Res>(_self.reconciliation!, (value) {
    return _then(_self.copyWith(reconciliation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClockRecord].
extension ClockRecordPatterns on ClockRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClockRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClockRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClockRecord value)  $default,){
final _that = this;
switch (_that) {
case _ClockRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClockRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ClockRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int employeeId,  String employeeName,  DateTime clockedInAt,  DateTime? clockedOutAt,  String? note,  CashReconciliation? reconciliation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClockRecord() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.clockedInAt,_that.clockedOutAt,_that.note,_that.reconciliation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int employeeId,  String employeeName,  DateTime clockedInAt,  DateTime? clockedOutAt,  String? note,  CashReconciliation? reconciliation)  $default,) {final _that = this;
switch (_that) {
case _ClockRecord():
return $default(_that.id,_that.employeeId,_that.employeeName,_that.clockedInAt,_that.clockedOutAt,_that.note,_that.reconciliation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int employeeId,  String employeeName,  DateTime clockedInAt,  DateTime? clockedOutAt,  String? note,  CashReconciliation? reconciliation)?  $default,) {final _that = this;
switch (_that) {
case _ClockRecord() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.clockedInAt,_that.clockedOutAt,_that.note,_that.reconciliation);case _:
  return null;

}
}

}

/// @nodoc


class _ClockRecord extends ClockRecord {
  const _ClockRecord({required this.id, required this.employeeId, required this.employeeName, required this.clockedInAt, this.clockedOutAt, this.note, this.reconciliation}): super._();
  

@override final  int id;
@override final  int employeeId;
@override final  String employeeName;
@override final  DateTime clockedInAt;
@override final  DateTime? clockedOutAt;
@override final  String? note;
// Null means the cash count was skipped at clock-out, not that it
// balanced (docs/features/04-volunteer-shift-accountability.md).
@override final  CashReconciliation? reconciliation;

/// Create a copy of ClockRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClockRecordCopyWith<_ClockRecord> get copyWith => __$ClockRecordCopyWithImpl<_ClockRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClockRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.clockedInAt, clockedInAt) || other.clockedInAt == clockedInAt)&&(identical(other.clockedOutAt, clockedOutAt) || other.clockedOutAt == clockedOutAt)&&(identical(other.note, note) || other.note == note)&&(identical(other.reconciliation, reconciliation) || other.reconciliation == reconciliation));
}


@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,clockedInAt,clockedOutAt,note,reconciliation);

@override
String toString() {
  return 'ClockRecord(id: $id, employeeId: $employeeId, employeeName: $employeeName, clockedInAt: $clockedInAt, clockedOutAt: $clockedOutAt, note: $note, reconciliation: $reconciliation)';
}


}

/// @nodoc
abstract mixin class _$ClockRecordCopyWith<$Res> implements $ClockRecordCopyWith<$Res> {
  factory _$ClockRecordCopyWith(_ClockRecord value, $Res Function(_ClockRecord) _then) = __$ClockRecordCopyWithImpl;
@override @useResult
$Res call({
 int id, int employeeId, String employeeName, DateTime clockedInAt, DateTime? clockedOutAt, String? note, CashReconciliation? reconciliation
});


@override $CashReconciliationCopyWith<$Res>? get reconciliation;

}
/// @nodoc
class __$ClockRecordCopyWithImpl<$Res>
    implements _$ClockRecordCopyWith<$Res> {
  __$ClockRecordCopyWithImpl(this._self, this._then);

  final _ClockRecord _self;
  final $Res Function(_ClockRecord) _then;

/// Create a copy of ClockRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? clockedInAt = null,Object? clockedOutAt = freezed,Object? note = freezed,Object? reconciliation = freezed,}) {
  return _then(_ClockRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,clockedInAt: null == clockedInAt ? _self.clockedInAt : clockedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,clockedOutAt: freezed == clockedOutAt ? _self.clockedOutAt : clockedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,reconciliation: freezed == reconciliation ? _self.reconciliation : reconciliation // ignore: cast_nullable_to_non_nullable
as CashReconciliation?,
  ));
}

/// Create a copy of ClockRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashReconciliationCopyWith<$Res>? get reconciliation {
    if (_self.reconciliation == null) {
    return null;
  }

  return $CashReconciliationCopyWith<$Res>(_self.reconciliation!, (value) {
    return _then(_self.copyWith(reconciliation: value));
  });
}
}

// dart format on
