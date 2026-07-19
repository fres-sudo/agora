// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_reconciliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashReconciliation {

 int get id; int get clockRecordId; int get expectedCents; int get countedCents; int get varianceCents; String? get note; DateTime? get createdAt;
/// Create a copy of CashReconciliation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashReconciliationCopyWith<CashReconciliation> get copyWith => _$CashReconciliationCopyWithImpl<CashReconciliation>(this as CashReconciliation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashReconciliation&&(identical(other.id, id) || other.id == id)&&(identical(other.clockRecordId, clockRecordId) || other.clockRecordId == clockRecordId)&&(identical(other.expectedCents, expectedCents) || other.expectedCents == expectedCents)&&(identical(other.countedCents, countedCents) || other.countedCents == countedCents)&&(identical(other.varianceCents, varianceCents) || other.varianceCents == varianceCents)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,clockRecordId,expectedCents,countedCents,varianceCents,note,createdAt);

@override
String toString() {
  return 'CashReconciliation(id: $id, clockRecordId: $clockRecordId, expectedCents: $expectedCents, countedCents: $countedCents, varianceCents: $varianceCents, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CashReconciliationCopyWith<$Res>  {
  factory $CashReconciliationCopyWith(CashReconciliation value, $Res Function(CashReconciliation) _then) = _$CashReconciliationCopyWithImpl;
@useResult
$Res call({
 int id, int clockRecordId, int expectedCents, int countedCents, int varianceCents, String? note, DateTime? createdAt
});




}
/// @nodoc
class _$CashReconciliationCopyWithImpl<$Res>
    implements $CashReconciliationCopyWith<$Res> {
  _$CashReconciliationCopyWithImpl(this._self, this._then);

  final CashReconciliation _self;
  final $Res Function(CashReconciliation) _then;

/// Create a copy of CashReconciliation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clockRecordId = null,Object? expectedCents = null,Object? countedCents = null,Object? varianceCents = null,Object? note = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,clockRecordId: null == clockRecordId ? _self.clockRecordId : clockRecordId // ignore: cast_nullable_to_non_nullable
as int,expectedCents: null == expectedCents ? _self.expectedCents : expectedCents // ignore: cast_nullable_to_non_nullable
as int,countedCents: null == countedCents ? _self.countedCents : countedCents // ignore: cast_nullable_to_non_nullable
as int,varianceCents: null == varianceCents ? _self.varianceCents : varianceCents // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashReconciliation].
extension CashReconciliationPatterns on CashReconciliation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashReconciliation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashReconciliation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashReconciliation value)  $default,){
final _that = this;
switch (_that) {
case _CashReconciliation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashReconciliation value)?  $default,){
final _that = this;
switch (_that) {
case _CashReconciliation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int clockRecordId,  int expectedCents,  int countedCents,  int varianceCents,  String? note,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashReconciliation() when $default != null:
return $default(_that.id,_that.clockRecordId,_that.expectedCents,_that.countedCents,_that.varianceCents,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int clockRecordId,  int expectedCents,  int countedCents,  int varianceCents,  String? note,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _CashReconciliation():
return $default(_that.id,_that.clockRecordId,_that.expectedCents,_that.countedCents,_that.varianceCents,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int clockRecordId,  int expectedCents,  int countedCents,  int varianceCents,  String? note,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CashReconciliation() when $default != null:
return $default(_that.id,_that.clockRecordId,_that.expectedCents,_that.countedCents,_that.varianceCents,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _CashReconciliation extends CashReconciliation {
  const _CashReconciliation({required this.id, required this.clockRecordId, required this.expectedCents, required this.countedCents, required this.varianceCents, this.note, this.createdAt}): super._();
  

@override final  int id;
@override final  int clockRecordId;
@override final  int expectedCents;
@override final  int countedCents;
@override final  int varianceCents;
@override final  String? note;
@override final  DateTime? createdAt;

/// Create a copy of CashReconciliation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashReconciliationCopyWith<_CashReconciliation> get copyWith => __$CashReconciliationCopyWithImpl<_CashReconciliation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashReconciliation&&(identical(other.id, id) || other.id == id)&&(identical(other.clockRecordId, clockRecordId) || other.clockRecordId == clockRecordId)&&(identical(other.expectedCents, expectedCents) || other.expectedCents == expectedCents)&&(identical(other.countedCents, countedCents) || other.countedCents == countedCents)&&(identical(other.varianceCents, varianceCents) || other.varianceCents == varianceCents)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,clockRecordId,expectedCents,countedCents,varianceCents,note,createdAt);

@override
String toString() {
  return 'CashReconciliation(id: $id, clockRecordId: $clockRecordId, expectedCents: $expectedCents, countedCents: $countedCents, varianceCents: $varianceCents, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CashReconciliationCopyWith<$Res> implements $CashReconciliationCopyWith<$Res> {
  factory _$CashReconciliationCopyWith(_CashReconciliation value, $Res Function(_CashReconciliation) _then) = __$CashReconciliationCopyWithImpl;
@override @useResult
$Res call({
 int id, int clockRecordId, int expectedCents, int countedCents, int varianceCents, String? note, DateTime? createdAt
});




}
/// @nodoc
class __$CashReconciliationCopyWithImpl<$Res>
    implements _$CashReconciliationCopyWith<$Res> {
  __$CashReconciliationCopyWithImpl(this._self, this._then);

  final _CashReconciliation _self;
  final $Res Function(_CashReconciliation) _then;

/// Create a copy of CashReconciliation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clockRecordId = null,Object? expectedCents = null,Object? countedCents = null,Object? varianceCents = null,Object? note = freezed,Object? createdAt = freezed,}) {
  return _then(_CashReconciliation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,clockRecordId: null == clockRecordId ? _self.clockRecordId : clockRecordId // ignore: cast_nullable_to_non_nullable
as int,expectedCents: null == expectedCents ? _self.expectedCents : expectedCents // ignore: cast_nullable_to_non_nullable
as int,countedCents: null == countedCents ? _self.countedCents : countedCents // ignore: cast_nullable_to_non_nullable
as int,varianceCents: null == varianceCents ? _self.varianceCents : varianceCents // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
