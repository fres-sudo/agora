// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportSummary {

/// Number of completed orders in the period.
 int get totalOrders;/// Sum of `grandTotalCents` across completed orders.
 int get totalRevenueCents;/// Sum of `discountCents` across completed orders.
 int get totalDiscountCents;/// Total quantity of line items sold across completed orders.
 int get itemsSold;/// Average completed-order value in cents (`revenue / orders`).
 int get averageTicketCents;/// Revenue taken in cash, in cents.
 int get cashRevenueCents;/// Revenue taken by card, in cents.
 int get cardRevenueCents;/// Sum of cash-reconciliation varianceCents across shifts closed within
/// the period (docs/features/04-volunteer-shift-accountability.md).
/// Negative means a net shortfall, positive a net overage.
 int get cashVarianceCents;/// Hour of day (0–23) with the most completed orders, or null if none.
 int? get peakHour;
/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportSummaryCopyWith<ReportSummary> get copyWith => _$ReportSummaryCopyWithImpl<ReportSummary>(this as ReportSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportSummary&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalRevenueCents, totalRevenueCents) || other.totalRevenueCents == totalRevenueCents)&&(identical(other.totalDiscountCents, totalDiscountCents) || other.totalDiscountCents == totalDiscountCents)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.averageTicketCents, averageTicketCents) || other.averageTicketCents == averageTicketCents)&&(identical(other.cashRevenueCents, cashRevenueCents) || other.cashRevenueCents == cashRevenueCents)&&(identical(other.cardRevenueCents, cardRevenueCents) || other.cardRevenueCents == cardRevenueCents)&&(identical(other.cashVarianceCents, cashVarianceCents) || other.cashVarianceCents == cashVarianceCents)&&(identical(other.peakHour, peakHour) || other.peakHour == peakHour));
}


@override
int get hashCode => Object.hash(runtimeType,totalOrders,totalRevenueCents,totalDiscountCents,itemsSold,averageTicketCents,cashRevenueCents,cardRevenueCents,cashVarianceCents,peakHour);

@override
String toString() {
  return 'ReportSummary(totalOrders: $totalOrders, totalRevenueCents: $totalRevenueCents, totalDiscountCents: $totalDiscountCents, itemsSold: $itemsSold, averageTicketCents: $averageTicketCents, cashRevenueCents: $cashRevenueCents, cardRevenueCents: $cardRevenueCents, cashVarianceCents: $cashVarianceCents, peakHour: $peakHour)';
}


}

/// @nodoc
abstract mixin class $ReportSummaryCopyWith<$Res>  {
  factory $ReportSummaryCopyWith(ReportSummary value, $Res Function(ReportSummary) _then) = _$ReportSummaryCopyWithImpl;
@useResult
$Res call({
 int totalOrders, int totalRevenueCents, int totalDiscountCents, int itemsSold, int averageTicketCents, int cashRevenueCents, int cardRevenueCents, int cashVarianceCents, int? peakHour
});




}
/// @nodoc
class _$ReportSummaryCopyWithImpl<$Res>
    implements $ReportSummaryCopyWith<$Res> {
  _$ReportSummaryCopyWithImpl(this._self, this._then);

  final ReportSummary _self;
  final $Res Function(ReportSummary) _then;

/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalOrders = null,Object? totalRevenueCents = null,Object? totalDiscountCents = null,Object? itemsSold = null,Object? averageTicketCents = null,Object? cashRevenueCents = null,Object? cardRevenueCents = null,Object? cashVarianceCents = null,Object? peakHour = freezed,}) {
  return _then(_self.copyWith(
totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalRevenueCents: null == totalRevenueCents ? _self.totalRevenueCents : totalRevenueCents // ignore: cast_nullable_to_non_nullable
as int,totalDiscountCents: null == totalDiscountCents ? _self.totalDiscountCents : totalDiscountCents // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,averageTicketCents: null == averageTicketCents ? _self.averageTicketCents : averageTicketCents // ignore: cast_nullable_to_non_nullable
as int,cashRevenueCents: null == cashRevenueCents ? _self.cashRevenueCents : cashRevenueCents // ignore: cast_nullable_to_non_nullable
as int,cardRevenueCents: null == cardRevenueCents ? _self.cardRevenueCents : cardRevenueCents // ignore: cast_nullable_to_non_nullable
as int,cashVarianceCents: null == cashVarianceCents ? _self.cashVarianceCents : cashVarianceCents // ignore: cast_nullable_to_non_nullable
as int,peakHour: freezed == peakHour ? _self.peakHour : peakHour // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportSummary].
extension ReportSummaryPatterns on ReportSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReportSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalOrders,  int totalRevenueCents,  int totalDiscountCents,  int itemsSold,  int averageTicketCents,  int cashRevenueCents,  int cardRevenueCents,  int cashVarianceCents,  int? peakHour)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
return $default(_that.totalOrders,_that.totalRevenueCents,_that.totalDiscountCents,_that.itemsSold,_that.averageTicketCents,_that.cashRevenueCents,_that.cardRevenueCents,_that.cashVarianceCents,_that.peakHour);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalOrders,  int totalRevenueCents,  int totalDiscountCents,  int itemsSold,  int averageTicketCents,  int cashRevenueCents,  int cardRevenueCents,  int cashVarianceCents,  int? peakHour)  $default,) {final _that = this;
switch (_that) {
case _ReportSummary():
return $default(_that.totalOrders,_that.totalRevenueCents,_that.totalDiscountCents,_that.itemsSold,_that.averageTicketCents,_that.cashRevenueCents,_that.cardRevenueCents,_that.cashVarianceCents,_that.peakHour);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalOrders,  int totalRevenueCents,  int totalDiscountCents,  int itemsSold,  int averageTicketCents,  int cashRevenueCents,  int cardRevenueCents,  int cashVarianceCents,  int? peakHour)?  $default,) {final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
return $default(_that.totalOrders,_that.totalRevenueCents,_that.totalDiscountCents,_that.itemsSold,_that.averageTicketCents,_that.cashRevenueCents,_that.cardRevenueCents,_that.cashVarianceCents,_that.peakHour);case _:
  return null;

}
}

}

/// @nodoc


class _ReportSummary extends ReportSummary {
  const _ReportSummary({this.totalOrders = 0, this.totalRevenueCents = 0, this.totalDiscountCents = 0, this.itemsSold = 0, this.averageTicketCents = 0, this.cashRevenueCents = 0, this.cardRevenueCents = 0, this.cashVarianceCents = 0, this.peakHour}): super._();
  

/// Number of completed orders in the period.
@override@JsonKey() final  int totalOrders;
/// Sum of `grandTotalCents` across completed orders.
@override@JsonKey() final  int totalRevenueCents;
/// Sum of `discountCents` across completed orders.
@override@JsonKey() final  int totalDiscountCents;
/// Total quantity of line items sold across completed orders.
@override@JsonKey() final  int itemsSold;
/// Average completed-order value in cents (`revenue / orders`).
@override@JsonKey() final  int averageTicketCents;
/// Revenue taken in cash, in cents.
@override@JsonKey() final  int cashRevenueCents;
/// Revenue taken by card, in cents.
@override@JsonKey() final  int cardRevenueCents;
/// Sum of cash-reconciliation varianceCents across shifts closed within
/// the period (docs/features/04-volunteer-shift-accountability.md).
/// Negative means a net shortfall, positive a net overage.
@override@JsonKey() final  int cashVarianceCents;
/// Hour of day (0–23) with the most completed orders, or null if none.
@override final  int? peakHour;

/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportSummaryCopyWith<_ReportSummary> get copyWith => __$ReportSummaryCopyWithImpl<_ReportSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportSummary&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalRevenueCents, totalRevenueCents) || other.totalRevenueCents == totalRevenueCents)&&(identical(other.totalDiscountCents, totalDiscountCents) || other.totalDiscountCents == totalDiscountCents)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.averageTicketCents, averageTicketCents) || other.averageTicketCents == averageTicketCents)&&(identical(other.cashRevenueCents, cashRevenueCents) || other.cashRevenueCents == cashRevenueCents)&&(identical(other.cardRevenueCents, cardRevenueCents) || other.cardRevenueCents == cardRevenueCents)&&(identical(other.cashVarianceCents, cashVarianceCents) || other.cashVarianceCents == cashVarianceCents)&&(identical(other.peakHour, peakHour) || other.peakHour == peakHour));
}


@override
int get hashCode => Object.hash(runtimeType,totalOrders,totalRevenueCents,totalDiscountCents,itemsSold,averageTicketCents,cashRevenueCents,cardRevenueCents,cashVarianceCents,peakHour);

@override
String toString() {
  return 'ReportSummary(totalOrders: $totalOrders, totalRevenueCents: $totalRevenueCents, totalDiscountCents: $totalDiscountCents, itemsSold: $itemsSold, averageTicketCents: $averageTicketCents, cashRevenueCents: $cashRevenueCents, cardRevenueCents: $cardRevenueCents, cashVarianceCents: $cashVarianceCents, peakHour: $peakHour)';
}


}

/// @nodoc
abstract mixin class _$ReportSummaryCopyWith<$Res> implements $ReportSummaryCopyWith<$Res> {
  factory _$ReportSummaryCopyWith(_ReportSummary value, $Res Function(_ReportSummary) _then) = __$ReportSummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalOrders, int totalRevenueCents, int totalDiscountCents, int itemsSold, int averageTicketCents, int cashRevenueCents, int cardRevenueCents, int cashVarianceCents, int? peakHour
});




}
/// @nodoc
class __$ReportSummaryCopyWithImpl<$Res>
    implements _$ReportSummaryCopyWith<$Res> {
  __$ReportSummaryCopyWithImpl(this._self, this._then);

  final _ReportSummary _self;
  final $Res Function(_ReportSummary) _then;

/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalOrders = null,Object? totalRevenueCents = null,Object? totalDiscountCents = null,Object? itemsSold = null,Object? averageTicketCents = null,Object? cashRevenueCents = null,Object? cardRevenueCents = null,Object? cashVarianceCents = null,Object? peakHour = freezed,}) {
  return _then(_ReportSummary(
totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalRevenueCents: null == totalRevenueCents ? _self.totalRevenueCents : totalRevenueCents // ignore: cast_nullable_to_non_nullable
as int,totalDiscountCents: null == totalDiscountCents ? _self.totalDiscountCents : totalDiscountCents // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,averageTicketCents: null == averageTicketCents ? _self.averageTicketCents : averageTicketCents // ignore: cast_nullable_to_non_nullable
as int,cashRevenueCents: null == cashRevenueCents ? _self.cashRevenueCents : cashRevenueCents // ignore: cast_nullable_to_non_nullable
as int,cardRevenueCents: null == cardRevenueCents ? _self.cardRevenueCents : cardRevenueCents // ignore: cast_nullable_to_non_nullable
as int,cashVarianceCents: null == cashVarianceCents ? _self.cashVarianceCents : cashVarianceCents // ignore: cast_nullable_to_non_nullable
as int,peakHour: freezed == peakHour ? _self.peakHour : peakHour // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$SalesPoint {

/// Axis label for this bucket (e.g. `14` for 2pm, or `Mon`).
 String get label;/// Revenue in cents accumulated within the bucket.
 int get revenueCents;
/// Create a copy of SalesPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesPointCopyWith<SalesPoint> get copyWith => _$SalesPointCopyWithImpl<SalesPoint>(this as SalesPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.revenueCents, revenueCents) || other.revenueCents == revenueCents));
}


@override
int get hashCode => Object.hash(runtimeType,label,revenueCents);

@override
String toString() {
  return 'SalesPoint(label: $label, revenueCents: $revenueCents)';
}


}

/// @nodoc
abstract mixin class $SalesPointCopyWith<$Res>  {
  factory $SalesPointCopyWith(SalesPoint value, $Res Function(SalesPoint) _then) = _$SalesPointCopyWithImpl;
@useResult
$Res call({
 String label, int revenueCents
});




}
/// @nodoc
class _$SalesPointCopyWithImpl<$Res>
    implements $SalesPointCopyWith<$Res> {
  _$SalesPointCopyWithImpl(this._self, this._then);

  final SalesPoint _self;
  final $Res Function(SalesPoint) _then;

/// Create a copy of SalesPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? revenueCents = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,revenueCents: null == revenueCents ? _self.revenueCents : revenueCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesPoint].
extension SalesPointPatterns on SalesPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesPoint value)  $default,){
final _that = this;
switch (_that) {
case _SalesPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesPoint value)?  $default,){
final _that = this;
switch (_that) {
case _SalesPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int revenueCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesPoint() when $default != null:
return $default(_that.label,_that.revenueCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int revenueCents)  $default,) {final _that = this;
switch (_that) {
case _SalesPoint():
return $default(_that.label,_that.revenueCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int revenueCents)?  $default,) {final _that = this;
switch (_that) {
case _SalesPoint() when $default != null:
return $default(_that.label,_that.revenueCents);case _:
  return null;

}
}

}

/// @nodoc


class _SalesPoint extends SalesPoint {
  const _SalesPoint({required this.label, required this.revenueCents}): super._();
  

/// Axis label for this bucket (e.g. `14` for 2pm, or `Mon`).
@override final  String label;
/// Revenue in cents accumulated within the bucket.
@override final  int revenueCents;

/// Create a copy of SalesPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesPointCopyWith<_SalesPoint> get copyWith => __$SalesPointCopyWithImpl<_SalesPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.revenueCents, revenueCents) || other.revenueCents == revenueCents));
}


@override
int get hashCode => Object.hash(runtimeType,label,revenueCents);

@override
String toString() {
  return 'SalesPoint(label: $label, revenueCents: $revenueCents)';
}


}

/// @nodoc
abstract mixin class _$SalesPointCopyWith<$Res> implements $SalesPointCopyWith<$Res> {
  factory _$SalesPointCopyWith(_SalesPoint value, $Res Function(_SalesPoint) _then) = __$SalesPointCopyWithImpl;
@override @useResult
$Res call({
 String label, int revenueCents
});




}
/// @nodoc
class __$SalesPointCopyWithImpl<$Res>
    implements _$SalesPointCopyWith<$Res> {
  __$SalesPointCopyWithImpl(this._self, this._then);

  final _SalesPoint _self;
  final $Res Function(_SalesPoint) _then;

/// Create a copy of SalesPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? revenueCents = null,}) {
  return _then(_SalesPoint(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,revenueCents: null == revenueCents ? _self.revenueCents : revenueCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ReportTopProduct {

 String get name; int get quantitySold; int get revenueCents;
/// Create a copy of ReportTopProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTopProductCopyWith<ReportTopProduct> get copyWith => _$ReportTopProductCopyWithImpl<ReportTopProduct>(this as ReportTopProduct, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTopProduct&&(identical(other.name, name) || other.name == name)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenueCents, revenueCents) || other.revenueCents == revenueCents));
}


@override
int get hashCode => Object.hash(runtimeType,name,quantitySold,revenueCents);

@override
String toString() {
  return 'ReportTopProduct(name: $name, quantitySold: $quantitySold, revenueCents: $revenueCents)';
}


}

/// @nodoc
abstract mixin class $ReportTopProductCopyWith<$Res>  {
  factory $ReportTopProductCopyWith(ReportTopProduct value, $Res Function(ReportTopProduct) _then) = _$ReportTopProductCopyWithImpl;
@useResult
$Res call({
 String name, int quantitySold, int revenueCents
});




}
/// @nodoc
class _$ReportTopProductCopyWithImpl<$Res>
    implements $ReportTopProductCopyWith<$Res> {
  _$ReportTopProductCopyWithImpl(this._self, this._then);

  final ReportTopProduct _self;
  final $Res Function(ReportTopProduct) _then;

/// Create a copy of ReportTopProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantitySold = null,Object? revenueCents = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenueCents: null == revenueCents ? _self.revenueCents : revenueCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportTopProduct].
extension ReportTopProductPatterns on ReportTopProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTopProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTopProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTopProduct value)  $default,){
final _that = this;
switch (_that) {
case _ReportTopProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTopProduct value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTopProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int quantitySold,  int revenueCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTopProduct() when $default != null:
return $default(_that.name,_that.quantitySold,_that.revenueCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int quantitySold,  int revenueCents)  $default,) {final _that = this;
switch (_that) {
case _ReportTopProduct():
return $default(_that.name,_that.quantitySold,_that.revenueCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int quantitySold,  int revenueCents)?  $default,) {final _that = this;
switch (_that) {
case _ReportTopProduct() when $default != null:
return $default(_that.name,_that.quantitySold,_that.revenueCents);case _:
  return null;

}
}

}

/// @nodoc


class _ReportTopProduct extends ReportTopProduct {
  const _ReportTopProduct({required this.name, required this.quantitySold, required this.revenueCents}): super._();
  

@override final  String name;
@override final  int quantitySold;
@override final  int revenueCents;

/// Create a copy of ReportTopProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTopProductCopyWith<_ReportTopProduct> get copyWith => __$ReportTopProductCopyWithImpl<_ReportTopProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTopProduct&&(identical(other.name, name) || other.name == name)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenueCents, revenueCents) || other.revenueCents == revenueCents));
}


@override
int get hashCode => Object.hash(runtimeType,name,quantitySold,revenueCents);

@override
String toString() {
  return 'ReportTopProduct(name: $name, quantitySold: $quantitySold, revenueCents: $revenueCents)';
}


}

/// @nodoc
abstract mixin class _$ReportTopProductCopyWith<$Res> implements $ReportTopProductCopyWith<$Res> {
  factory _$ReportTopProductCopyWith(_ReportTopProduct value, $Res Function(_ReportTopProduct) _then) = __$ReportTopProductCopyWithImpl;
@override @useResult
$Res call({
 String name, int quantitySold, int revenueCents
});




}
/// @nodoc
class __$ReportTopProductCopyWithImpl<$Res>
    implements _$ReportTopProductCopyWith<$Res> {
  __$ReportTopProductCopyWithImpl(this._self, this._then);

  final _ReportTopProduct _self;
  final $Res Function(_ReportTopProduct) _then;

/// Create a copy of ReportTopProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantitySold = null,Object? revenueCents = null,}) {
  return _then(_ReportTopProduct(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenueCents: null == revenueCents ? _self.revenueCents : revenueCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrderStatusBreakdown {

 int get completed; int get pending; int get voided;
/// Create a copy of OrderStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderStatusBreakdownCopyWith<OrderStatusBreakdown> get copyWith => _$OrderStatusBreakdownCopyWithImpl<OrderStatusBreakdown>(this as OrderStatusBreakdown, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderStatusBreakdown&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.voided, voided) || other.voided == voided));
}


@override
int get hashCode => Object.hash(runtimeType,completed,pending,voided);

@override
String toString() {
  return 'OrderStatusBreakdown(completed: $completed, pending: $pending, voided: $voided)';
}


}

/// @nodoc
abstract mixin class $OrderStatusBreakdownCopyWith<$Res>  {
  factory $OrderStatusBreakdownCopyWith(OrderStatusBreakdown value, $Res Function(OrderStatusBreakdown) _then) = _$OrderStatusBreakdownCopyWithImpl;
@useResult
$Res call({
 int completed, int pending, int voided
});




}
/// @nodoc
class _$OrderStatusBreakdownCopyWithImpl<$Res>
    implements $OrderStatusBreakdownCopyWith<$Res> {
  _$OrderStatusBreakdownCopyWithImpl(this._self, this._then);

  final OrderStatusBreakdown _self;
  final $Res Function(OrderStatusBreakdown) _then;

/// Create a copy of OrderStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completed = null,Object? pending = null,Object? voided = null,}) {
  return _then(_self.copyWith(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,voided: null == voided ? _self.voided : voided // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderStatusBreakdown].
extension OrderStatusBreakdownPatterns on OrderStatusBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderStatusBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderStatusBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderStatusBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _OrderStatusBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderStatusBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _OrderStatusBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int completed,  int pending,  int voided)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderStatusBreakdown() when $default != null:
return $default(_that.completed,_that.pending,_that.voided);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int completed,  int pending,  int voided)  $default,) {final _that = this;
switch (_that) {
case _OrderStatusBreakdown():
return $default(_that.completed,_that.pending,_that.voided);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int completed,  int pending,  int voided)?  $default,) {final _that = this;
switch (_that) {
case _OrderStatusBreakdown() when $default != null:
return $default(_that.completed,_that.pending,_that.voided);case _:
  return null;

}
}

}

/// @nodoc


class _OrderStatusBreakdown extends OrderStatusBreakdown {
  const _OrderStatusBreakdown({this.completed = 0, this.pending = 0, this.voided = 0}): super._();
  

@override@JsonKey() final  int completed;
@override@JsonKey() final  int pending;
@override@JsonKey() final  int voided;

/// Create a copy of OrderStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusBreakdownCopyWith<_OrderStatusBreakdown> get copyWith => __$OrderStatusBreakdownCopyWithImpl<_OrderStatusBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusBreakdown&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.voided, voided) || other.voided == voided));
}


@override
int get hashCode => Object.hash(runtimeType,completed,pending,voided);

@override
String toString() {
  return 'OrderStatusBreakdown(completed: $completed, pending: $pending, voided: $voided)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusBreakdownCopyWith<$Res> implements $OrderStatusBreakdownCopyWith<$Res> {
  factory _$OrderStatusBreakdownCopyWith(_OrderStatusBreakdown value, $Res Function(_OrderStatusBreakdown) _then) = __$OrderStatusBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int completed, int pending, int voided
});




}
/// @nodoc
class __$OrderStatusBreakdownCopyWithImpl<$Res>
    implements _$OrderStatusBreakdownCopyWith<$Res> {
  __$OrderStatusBreakdownCopyWithImpl(this._self, this._then);

  final _OrderStatusBreakdown _self;
  final $Res Function(_OrderStatusBreakdown) _then;

/// Create a copy of OrderStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completed = null,Object? pending = null,Object? voided = null,}) {
  return _then(_OrderStatusBreakdown(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,voided: null == voided ? _self.voided : voided // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StockBreakdown {

 int get inStock; int get lowStock; int get outOfStock;
/// Create a copy of StockBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockBreakdownCopyWith<StockBreakdown> get copyWith => _$StockBreakdownCopyWithImpl<StockBreakdown>(this as StockBreakdown, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockBreakdown&&(identical(other.inStock, inStock) || other.inStock == inStock)&&(identical(other.lowStock, lowStock) || other.lowStock == lowStock)&&(identical(other.outOfStock, outOfStock) || other.outOfStock == outOfStock));
}


@override
int get hashCode => Object.hash(runtimeType,inStock,lowStock,outOfStock);

@override
String toString() {
  return 'StockBreakdown(inStock: $inStock, lowStock: $lowStock, outOfStock: $outOfStock)';
}


}

/// @nodoc
abstract mixin class $StockBreakdownCopyWith<$Res>  {
  factory $StockBreakdownCopyWith(StockBreakdown value, $Res Function(StockBreakdown) _then) = _$StockBreakdownCopyWithImpl;
@useResult
$Res call({
 int inStock, int lowStock, int outOfStock
});




}
/// @nodoc
class _$StockBreakdownCopyWithImpl<$Res>
    implements $StockBreakdownCopyWith<$Res> {
  _$StockBreakdownCopyWithImpl(this._self, this._then);

  final StockBreakdown _self;
  final $Res Function(StockBreakdown) _then;

/// Create a copy of StockBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inStock = null,Object? lowStock = null,Object? outOfStock = null,}) {
  return _then(_self.copyWith(
inStock: null == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as int,lowStock: null == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as int,outOfStock: null == outOfStock ? _self.outOfStock : outOfStock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StockBreakdown].
extension StockBreakdownPatterns on StockBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _StockBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _StockBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int inStock,  int lowStock,  int outOfStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockBreakdown() when $default != null:
return $default(_that.inStock,_that.lowStock,_that.outOfStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int inStock,  int lowStock,  int outOfStock)  $default,) {final _that = this;
switch (_that) {
case _StockBreakdown():
return $default(_that.inStock,_that.lowStock,_that.outOfStock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int inStock,  int lowStock,  int outOfStock)?  $default,) {final _that = this;
switch (_that) {
case _StockBreakdown() when $default != null:
return $default(_that.inStock,_that.lowStock,_that.outOfStock);case _:
  return null;

}
}

}

/// @nodoc


class _StockBreakdown extends StockBreakdown {
  const _StockBreakdown({this.inStock = 0, this.lowStock = 0, this.outOfStock = 0}): super._();
  

@override@JsonKey() final  int inStock;
@override@JsonKey() final  int lowStock;
@override@JsonKey() final  int outOfStock;

/// Create a copy of StockBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockBreakdownCopyWith<_StockBreakdown> get copyWith => __$StockBreakdownCopyWithImpl<_StockBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockBreakdown&&(identical(other.inStock, inStock) || other.inStock == inStock)&&(identical(other.lowStock, lowStock) || other.lowStock == lowStock)&&(identical(other.outOfStock, outOfStock) || other.outOfStock == outOfStock));
}


@override
int get hashCode => Object.hash(runtimeType,inStock,lowStock,outOfStock);

@override
String toString() {
  return 'StockBreakdown(inStock: $inStock, lowStock: $lowStock, outOfStock: $outOfStock)';
}


}

/// @nodoc
abstract mixin class _$StockBreakdownCopyWith<$Res> implements $StockBreakdownCopyWith<$Res> {
  factory _$StockBreakdownCopyWith(_StockBreakdown value, $Res Function(_StockBreakdown) _then) = __$StockBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int inStock, int lowStock, int outOfStock
});




}
/// @nodoc
class __$StockBreakdownCopyWithImpl<$Res>
    implements _$StockBreakdownCopyWith<$Res> {
  __$StockBreakdownCopyWithImpl(this._self, this._then);

  final _StockBreakdown _self;
  final $Res Function(_StockBreakdown) _then;

/// Create a copy of StockBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inStock = null,Object? lowStock = null,Object? outOfStock = null,}) {
  return _then(_StockBreakdown(
inStock: null == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as int,lowStock: null == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as int,outOfStock: null == outOfStock ? _self.outOfStock : outOfStock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ReportData {

 ReportSummary get summary; OrderStatusBreakdown get statusBreakdown; StockBreakdown get stockBreakdown; List<SalesPoint> get salesTrend; List<ReportTopProduct> get topProducts; List<Order> get recentOrders;
/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportDataCopyWith<ReportData> get copyWith => _$ReportDataCopyWithImpl<ReportData>(this as ReportData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportData&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.statusBreakdown, statusBreakdown) || other.statusBreakdown == statusBreakdown)&&(identical(other.stockBreakdown, stockBreakdown) || other.stockBreakdown == stockBreakdown)&&const DeepCollectionEquality().equals(other.salesTrend, salesTrend)&&const DeepCollectionEquality().equals(other.topProducts, topProducts)&&const DeepCollectionEquality().equals(other.recentOrders, recentOrders));
}


@override
int get hashCode => Object.hash(runtimeType,summary,statusBreakdown,stockBreakdown,const DeepCollectionEquality().hash(salesTrend),const DeepCollectionEquality().hash(topProducts),const DeepCollectionEquality().hash(recentOrders));

@override
String toString() {
  return 'ReportData(summary: $summary, statusBreakdown: $statusBreakdown, stockBreakdown: $stockBreakdown, salesTrend: $salesTrend, topProducts: $topProducts, recentOrders: $recentOrders)';
}


}

/// @nodoc
abstract mixin class $ReportDataCopyWith<$Res>  {
  factory $ReportDataCopyWith(ReportData value, $Res Function(ReportData) _then) = _$ReportDataCopyWithImpl;
@useResult
$Res call({
 ReportSummary summary, OrderStatusBreakdown statusBreakdown, StockBreakdown stockBreakdown, List<SalesPoint> salesTrend, List<ReportTopProduct> topProducts, List<Order> recentOrders
});


$ReportSummaryCopyWith<$Res> get summary;$OrderStatusBreakdownCopyWith<$Res> get statusBreakdown;$StockBreakdownCopyWith<$Res> get stockBreakdown;

}
/// @nodoc
class _$ReportDataCopyWithImpl<$Res>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._self, this._then);

  final ReportData _self;
  final $Res Function(ReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? statusBreakdown = null,Object? stockBreakdown = null,Object? salesTrend = null,Object? topProducts = null,Object? recentOrders = null,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ReportSummary,statusBreakdown: null == statusBreakdown ? _self.statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as OrderStatusBreakdown,stockBreakdown: null == stockBreakdown ? _self.stockBreakdown : stockBreakdown // ignore: cast_nullable_to_non_nullable
as StockBreakdown,salesTrend: null == salesTrend ? _self.salesTrend : salesTrend // ignore: cast_nullable_to_non_nullable
as List<SalesPoint>,topProducts: null == topProducts ? _self.topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<ReportTopProduct>,recentOrders: null == recentOrders ? _self.recentOrders : recentOrders // ignore: cast_nullable_to_non_nullable
as List<Order>,
  ));
}
/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSummaryCopyWith<$Res> get summary {
  
  return $ReportSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderStatusBreakdownCopyWith<$Res> get statusBreakdown {
  
  return $OrderStatusBreakdownCopyWith<$Res>(_self.statusBreakdown, (value) {
    return _then(_self.copyWith(statusBreakdown: value));
  });
}/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockBreakdownCopyWith<$Res> get stockBreakdown {
  
  return $StockBreakdownCopyWith<$Res>(_self.stockBreakdown, (value) {
    return _then(_self.copyWith(stockBreakdown: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportData].
extension ReportDataPatterns on ReportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportData value)  $default,){
final _that = this;
switch (_that) {
case _ReportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportData value)?  $default,){
final _that = this;
switch (_that) {
case _ReportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportSummary summary,  OrderStatusBreakdown statusBreakdown,  StockBreakdown stockBreakdown,  List<SalesPoint> salesTrend,  List<ReportTopProduct> topProducts,  List<Order> recentOrders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportData() when $default != null:
return $default(_that.summary,_that.statusBreakdown,_that.stockBreakdown,_that.salesTrend,_that.topProducts,_that.recentOrders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportSummary summary,  OrderStatusBreakdown statusBreakdown,  StockBreakdown stockBreakdown,  List<SalesPoint> salesTrend,  List<ReportTopProduct> topProducts,  List<Order> recentOrders)  $default,) {final _that = this;
switch (_that) {
case _ReportData():
return $default(_that.summary,_that.statusBreakdown,_that.stockBreakdown,_that.salesTrend,_that.topProducts,_that.recentOrders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportSummary summary,  OrderStatusBreakdown statusBreakdown,  StockBreakdown stockBreakdown,  List<SalesPoint> salesTrend,  List<ReportTopProduct> topProducts,  List<Order> recentOrders)?  $default,) {final _that = this;
switch (_that) {
case _ReportData() when $default != null:
return $default(_that.summary,_that.statusBreakdown,_that.stockBreakdown,_that.salesTrend,_that.topProducts,_that.recentOrders);case _:
  return null;

}
}

}

/// @nodoc


class _ReportData extends ReportData {
  const _ReportData({required this.summary, required this.statusBreakdown, required this.stockBreakdown, final  List<SalesPoint> salesTrend = const [], final  List<ReportTopProduct> topProducts = const [], final  List<Order> recentOrders = const []}): _salesTrend = salesTrend,_topProducts = topProducts,_recentOrders = recentOrders,super._();
  

@override final  ReportSummary summary;
@override final  OrderStatusBreakdown statusBreakdown;
@override final  StockBreakdown stockBreakdown;
 final  List<SalesPoint> _salesTrend;
@override@JsonKey() List<SalesPoint> get salesTrend {
  if (_salesTrend is EqualUnmodifiableListView) return _salesTrend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_salesTrend);
}

 final  List<ReportTopProduct> _topProducts;
@override@JsonKey() List<ReportTopProduct> get topProducts {
  if (_topProducts is EqualUnmodifiableListView) return _topProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topProducts);
}

 final  List<Order> _recentOrders;
@override@JsonKey() List<Order> get recentOrders {
  if (_recentOrders is EqualUnmodifiableListView) return _recentOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentOrders);
}


/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportDataCopyWith<_ReportData> get copyWith => __$ReportDataCopyWithImpl<_ReportData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportData&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.statusBreakdown, statusBreakdown) || other.statusBreakdown == statusBreakdown)&&(identical(other.stockBreakdown, stockBreakdown) || other.stockBreakdown == stockBreakdown)&&const DeepCollectionEquality().equals(other._salesTrend, _salesTrend)&&const DeepCollectionEquality().equals(other._topProducts, _topProducts)&&const DeepCollectionEquality().equals(other._recentOrders, _recentOrders));
}


@override
int get hashCode => Object.hash(runtimeType,summary,statusBreakdown,stockBreakdown,const DeepCollectionEquality().hash(_salesTrend),const DeepCollectionEquality().hash(_topProducts),const DeepCollectionEquality().hash(_recentOrders));

@override
String toString() {
  return 'ReportData(summary: $summary, statusBreakdown: $statusBreakdown, stockBreakdown: $stockBreakdown, salesTrend: $salesTrend, topProducts: $topProducts, recentOrders: $recentOrders)';
}


}

/// @nodoc
abstract mixin class _$ReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory _$ReportDataCopyWith(_ReportData value, $Res Function(_ReportData) _then) = __$ReportDataCopyWithImpl;
@override @useResult
$Res call({
 ReportSummary summary, OrderStatusBreakdown statusBreakdown, StockBreakdown stockBreakdown, List<SalesPoint> salesTrend, List<ReportTopProduct> topProducts, List<Order> recentOrders
});


@override $ReportSummaryCopyWith<$Res> get summary;@override $OrderStatusBreakdownCopyWith<$Res> get statusBreakdown;@override $StockBreakdownCopyWith<$Res> get stockBreakdown;

}
/// @nodoc
class __$ReportDataCopyWithImpl<$Res>
    implements _$ReportDataCopyWith<$Res> {
  __$ReportDataCopyWithImpl(this._self, this._then);

  final _ReportData _self;
  final $Res Function(_ReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? statusBreakdown = null,Object? stockBreakdown = null,Object? salesTrend = null,Object? topProducts = null,Object? recentOrders = null,}) {
  return _then(_ReportData(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ReportSummary,statusBreakdown: null == statusBreakdown ? _self.statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as OrderStatusBreakdown,stockBreakdown: null == stockBreakdown ? _self.stockBreakdown : stockBreakdown // ignore: cast_nullable_to_non_nullable
as StockBreakdown,salesTrend: null == salesTrend ? _self._salesTrend : salesTrend // ignore: cast_nullable_to_non_nullable
as List<SalesPoint>,topProducts: null == topProducts ? _self._topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<ReportTopProduct>,recentOrders: null == recentOrders ? _self._recentOrders : recentOrders // ignore: cast_nullable_to_non_nullable
as List<Order>,
  ));
}

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSummaryCopyWith<$Res> get summary {
  
  return $ReportSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderStatusBreakdownCopyWith<$Res> get statusBreakdown {
  
  return $OrderStatusBreakdownCopyWith<$Res>(_self.statusBreakdown, (value) {
    return _then(_self.copyWith(statusBreakdown: value));
  });
}/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockBreakdownCopyWith<$Res> get stockBreakdown {
  
  return $StockBreakdownCopyWith<$Res>(_self.stockBreakdown, (value) {
    return _then(_self.copyWith(stockBreakdown: value));
  });
}
}

// dart format on
