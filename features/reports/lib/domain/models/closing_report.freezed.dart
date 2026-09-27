// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'closing_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClosingReport {

/// Set once persisted; null for an unsaved in-progress closure.
 int? get id;/// Start of the reporting window (inclusive).
 DateTime get periodStart;/// End of the reporting window (inclusive).
 DateTime get periodEnd;/// Number of completed orders in the period.
 int get totalOrders;/// Sum of [grandTotalCents] across completed orders (tax included).
 int get totalRevenueCents;/// Sum of [taxCents] across completed orders.
 int get totalTaxCents;/// Sum of [discountCents] across completed orders.
 int get totalDiscountCents;/// Revenue collected in cash, in cents.
 int get cashRevenueCents;/// Revenue collected by card, in cents.
 int get cardRevenueCents;/// Number of voided orders in the period.
 int get voidedOrders;/// Cash physically counted in the drawer by the operator.
/// Null if the operator skipped the cash-count step.
 int? get cashCountedCents;/// Free-text note from the operator (optional).
 String? get notes;/// Set to [DateTime.now()] at persist time.
 DateTime? get createdAt;
/// Create a copy of ClosingReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClosingReportCopyWith<ClosingReport> get copyWith => _$ClosingReportCopyWithImpl<ClosingReport>(this as ClosingReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClosingReport&&(identical(other.id, id) || other.id == id)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalRevenueCents, totalRevenueCents) || other.totalRevenueCents == totalRevenueCents)&&(identical(other.totalTaxCents, totalTaxCents) || other.totalTaxCents == totalTaxCents)&&(identical(other.totalDiscountCents, totalDiscountCents) || other.totalDiscountCents == totalDiscountCents)&&(identical(other.cashRevenueCents, cashRevenueCents) || other.cashRevenueCents == cashRevenueCents)&&(identical(other.cardRevenueCents, cardRevenueCents) || other.cardRevenueCents == cardRevenueCents)&&(identical(other.voidedOrders, voidedOrders) || other.voidedOrders == voidedOrders)&&(identical(other.cashCountedCents, cashCountedCents) || other.cashCountedCents == cashCountedCents)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,periodStart,periodEnd,totalOrders,totalRevenueCents,totalTaxCents,totalDiscountCents,cashRevenueCents,cardRevenueCents,voidedOrders,cashCountedCents,notes,createdAt);

@override
String toString() {
  return 'ClosingReport(id: $id, periodStart: $periodStart, periodEnd: $periodEnd, totalOrders: $totalOrders, totalRevenueCents: $totalRevenueCents, totalTaxCents: $totalTaxCents, totalDiscountCents: $totalDiscountCents, cashRevenueCents: $cashRevenueCents, cardRevenueCents: $cardRevenueCents, voidedOrders: $voidedOrders, cashCountedCents: $cashCountedCents, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ClosingReportCopyWith<$Res>  {
  factory $ClosingReportCopyWith(ClosingReport value, $Res Function(ClosingReport) _then) = _$ClosingReportCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime periodStart, DateTime periodEnd, int totalOrders, int totalRevenueCents, int totalTaxCents, int totalDiscountCents, int cashRevenueCents, int cardRevenueCents, int voidedOrders, int? cashCountedCents, String? notes, DateTime? createdAt
});




}
/// @nodoc
class _$ClosingReportCopyWithImpl<$Res>
    implements $ClosingReportCopyWith<$Res> {
  _$ClosingReportCopyWithImpl(this._self, this._then);

  final ClosingReport _self;
  final $Res Function(ClosingReport) _then;

/// Create a copy of ClosingReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? periodStart = null,Object? periodEnd = null,Object? totalOrders = null,Object? totalRevenueCents = null,Object? totalTaxCents = null,Object? totalDiscountCents = null,Object? cashRevenueCents = null,Object? cardRevenueCents = null,Object? voidedOrders = null,Object? cashCountedCents = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalRevenueCents: null == totalRevenueCents ? _self.totalRevenueCents : totalRevenueCents // ignore: cast_nullable_to_non_nullable
as int,totalTaxCents: null == totalTaxCents ? _self.totalTaxCents : totalTaxCents // ignore: cast_nullable_to_non_nullable
as int,totalDiscountCents: null == totalDiscountCents ? _self.totalDiscountCents : totalDiscountCents // ignore: cast_nullable_to_non_nullable
as int,cashRevenueCents: null == cashRevenueCents ? _self.cashRevenueCents : cashRevenueCents // ignore: cast_nullable_to_non_nullable
as int,cardRevenueCents: null == cardRevenueCents ? _self.cardRevenueCents : cardRevenueCents // ignore: cast_nullable_to_non_nullable
as int,voidedOrders: null == voidedOrders ? _self.voidedOrders : voidedOrders // ignore: cast_nullable_to_non_nullable
as int,cashCountedCents: freezed == cashCountedCents ? _self.cashCountedCents : cashCountedCents // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClosingReport].
extension ClosingReportPatterns on ClosingReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClosingReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClosingReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClosingReport value)  $default,){
final _that = this;
switch (_that) {
case _ClosingReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClosingReport value)?  $default,){
final _that = this;
switch (_that) {
case _ClosingReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime periodStart,  DateTime periodEnd,  int totalOrders,  int totalRevenueCents,  int totalTaxCents,  int totalDiscountCents,  int cashRevenueCents,  int cardRevenueCents,  int voidedOrders,  int? cashCountedCents,  String? notes,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClosingReport() when $default != null:
return $default(_that.id,_that.periodStart,_that.periodEnd,_that.totalOrders,_that.totalRevenueCents,_that.totalTaxCents,_that.totalDiscountCents,_that.cashRevenueCents,_that.cardRevenueCents,_that.voidedOrders,_that.cashCountedCents,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime periodStart,  DateTime periodEnd,  int totalOrders,  int totalRevenueCents,  int totalTaxCents,  int totalDiscountCents,  int cashRevenueCents,  int cardRevenueCents,  int voidedOrders,  int? cashCountedCents,  String? notes,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ClosingReport():
return $default(_that.id,_that.periodStart,_that.periodEnd,_that.totalOrders,_that.totalRevenueCents,_that.totalTaxCents,_that.totalDiscountCents,_that.cashRevenueCents,_that.cardRevenueCents,_that.voidedOrders,_that.cashCountedCents,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime periodStart,  DateTime periodEnd,  int totalOrders,  int totalRevenueCents,  int totalTaxCents,  int totalDiscountCents,  int cashRevenueCents,  int cardRevenueCents,  int voidedOrders,  int? cashCountedCents,  String? notes,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ClosingReport() when $default != null:
return $default(_that.id,_that.periodStart,_that.periodEnd,_that.totalOrders,_that.totalRevenueCents,_that.totalTaxCents,_that.totalDiscountCents,_that.cashRevenueCents,_that.cardRevenueCents,_that.voidedOrders,_that.cashCountedCents,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ClosingReport extends ClosingReport {
  const _ClosingReport({this.id, required this.periodStart, required this.periodEnd, required this.totalOrders, required this.totalRevenueCents, required this.totalTaxCents, required this.totalDiscountCents, required this.cashRevenueCents, required this.cardRevenueCents, required this.voidedOrders, this.cashCountedCents, this.notes, this.createdAt}): super._();
  

/// Set once persisted; null for an unsaved in-progress closure.
@override final  int? id;
/// Start of the reporting window (inclusive).
@override final  DateTime periodStart;
/// End of the reporting window (inclusive).
@override final  DateTime periodEnd;
/// Number of completed orders in the period.
@override final  int totalOrders;
/// Sum of [grandTotalCents] across completed orders (tax included).
@override final  int totalRevenueCents;
/// Sum of [taxCents] across completed orders.
@override final  int totalTaxCents;
/// Sum of [discountCents] across completed orders.
@override final  int totalDiscountCents;
/// Revenue collected in cash, in cents.
@override final  int cashRevenueCents;
/// Revenue collected by card, in cents.
@override final  int cardRevenueCents;
/// Number of voided orders in the period.
@override final  int voidedOrders;
/// Cash physically counted in the drawer by the operator.
/// Null if the operator skipped the cash-count step.
@override final  int? cashCountedCents;
/// Free-text note from the operator (optional).
@override final  String? notes;
/// Set to [DateTime.now()] at persist time.
@override final  DateTime? createdAt;

/// Create a copy of ClosingReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClosingReportCopyWith<_ClosingReport> get copyWith => __$ClosingReportCopyWithImpl<_ClosingReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClosingReport&&(identical(other.id, id) || other.id == id)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalRevenueCents, totalRevenueCents) || other.totalRevenueCents == totalRevenueCents)&&(identical(other.totalTaxCents, totalTaxCents) || other.totalTaxCents == totalTaxCents)&&(identical(other.totalDiscountCents, totalDiscountCents) || other.totalDiscountCents == totalDiscountCents)&&(identical(other.cashRevenueCents, cashRevenueCents) || other.cashRevenueCents == cashRevenueCents)&&(identical(other.cardRevenueCents, cardRevenueCents) || other.cardRevenueCents == cardRevenueCents)&&(identical(other.voidedOrders, voidedOrders) || other.voidedOrders == voidedOrders)&&(identical(other.cashCountedCents, cashCountedCents) || other.cashCountedCents == cashCountedCents)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,periodStart,periodEnd,totalOrders,totalRevenueCents,totalTaxCents,totalDiscountCents,cashRevenueCents,cardRevenueCents,voidedOrders,cashCountedCents,notes,createdAt);

@override
String toString() {
  return 'ClosingReport(id: $id, periodStart: $periodStart, periodEnd: $periodEnd, totalOrders: $totalOrders, totalRevenueCents: $totalRevenueCents, totalTaxCents: $totalTaxCents, totalDiscountCents: $totalDiscountCents, cashRevenueCents: $cashRevenueCents, cardRevenueCents: $cardRevenueCents, voidedOrders: $voidedOrders, cashCountedCents: $cashCountedCents, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ClosingReportCopyWith<$Res> implements $ClosingReportCopyWith<$Res> {
  factory _$ClosingReportCopyWith(_ClosingReport value, $Res Function(_ClosingReport) _then) = __$ClosingReportCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime periodStart, DateTime periodEnd, int totalOrders, int totalRevenueCents, int totalTaxCents, int totalDiscountCents, int cashRevenueCents, int cardRevenueCents, int voidedOrders, int? cashCountedCents, String? notes, DateTime? createdAt
});




}
/// @nodoc
class __$ClosingReportCopyWithImpl<$Res>
    implements _$ClosingReportCopyWith<$Res> {
  __$ClosingReportCopyWithImpl(this._self, this._then);

  final _ClosingReport _self;
  final $Res Function(_ClosingReport) _then;

/// Create a copy of ClosingReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? periodStart = null,Object? periodEnd = null,Object? totalOrders = null,Object? totalRevenueCents = null,Object? totalTaxCents = null,Object? totalDiscountCents = null,Object? cashRevenueCents = null,Object? cardRevenueCents = null,Object? voidedOrders = null,Object? cashCountedCents = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_ClosingReport(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalRevenueCents: null == totalRevenueCents ? _self.totalRevenueCents : totalRevenueCents // ignore: cast_nullable_to_non_nullable
as int,totalTaxCents: null == totalTaxCents ? _self.totalTaxCents : totalTaxCents // ignore: cast_nullable_to_non_nullable
as int,totalDiscountCents: null == totalDiscountCents ? _self.totalDiscountCents : totalDiscountCents // ignore: cast_nullable_to_non_nullable
as int,cashRevenueCents: null == cashRevenueCents ? _self.cashRevenueCents : cashRevenueCents // ignore: cast_nullable_to_non_nullable
as int,cardRevenueCents: null == cardRevenueCents ? _self.cardRevenueCents : cardRevenueCents // ignore: cast_nullable_to_non_nullable
as int,voidedOrders: null == voidedOrders ? _self.voidedOrders : voidedOrders // ignore: cast_nullable_to_non_nullable
as int,cashCountedCents: freezed == cashCountedCents ? _self.cashCountedCents : cashCountedCents // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
