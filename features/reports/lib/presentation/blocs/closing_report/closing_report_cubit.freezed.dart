// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'closing_report_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClosingReportState {

 ClosingReportStatus get status;/// The closure being built for the current session (not yet persisted).
 ClosingReport? get currentReport;/// All previously saved closures, newest first.
 List<ClosingReport> get history; String? get errorMessage;
/// Create a copy of ClosingReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClosingReportStateCopyWith<ClosingReportState> get copyWith => _$ClosingReportStateCopyWithImpl<ClosingReportState>(this as ClosingReportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClosingReportState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentReport, currentReport) || other.currentReport == currentReport)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentReport,const DeepCollectionEquality().hash(history),errorMessage);

@override
String toString() {
  return 'ClosingReportState(status: $status, currentReport: $currentReport, history: $history, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ClosingReportStateCopyWith<$Res>  {
  factory $ClosingReportStateCopyWith(ClosingReportState value, $Res Function(ClosingReportState) _then) = _$ClosingReportStateCopyWithImpl;
@useResult
$Res call({
 ClosingReportStatus status, ClosingReport? currentReport, List<ClosingReport> history, String? errorMessage
});


$ClosingReportCopyWith<$Res>? get currentReport;

}
/// @nodoc
class _$ClosingReportStateCopyWithImpl<$Res>
    implements $ClosingReportStateCopyWith<$Res> {
  _$ClosingReportStateCopyWithImpl(this._self, this._then);

  final ClosingReportState _self;
  final $Res Function(ClosingReportState) _then;

/// Create a copy of ClosingReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? currentReport = freezed,Object? history = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClosingReportStatus,currentReport: freezed == currentReport ? _self.currentReport : currentReport // ignore: cast_nullable_to_non_nullable
as ClosingReport?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ClosingReport>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ClosingReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClosingReportCopyWith<$Res>? get currentReport {
    if (_self.currentReport == null) {
    return null;
  }

  return $ClosingReportCopyWith<$Res>(_self.currentReport!, (value) {
    return _then(_self.copyWith(currentReport: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClosingReportState].
extension ClosingReportStatePatterns on ClosingReportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClosingReportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClosingReportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClosingReportState value)  $default,){
final _that = this;
switch (_that) {
case _ClosingReportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClosingReportState value)?  $default,){
final _that = this;
switch (_that) {
case _ClosingReportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ClosingReportStatus status,  ClosingReport? currentReport,  List<ClosingReport> history,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClosingReportState() when $default != null:
return $default(_that.status,_that.currentReport,_that.history,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ClosingReportStatus status,  ClosingReport? currentReport,  List<ClosingReport> history,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ClosingReportState():
return $default(_that.status,_that.currentReport,_that.history,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ClosingReportStatus status,  ClosingReport? currentReport,  List<ClosingReport> history,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ClosingReportState() when $default != null:
return $default(_that.status,_that.currentReport,_that.history,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ClosingReportState extends ClosingReportState {
  const _ClosingReportState({this.status = ClosingReportStatus.initial, this.currentReport, final  List<ClosingReport> history = const [], this.errorMessage}): _history = history,super._();
  

@override@JsonKey() final  ClosingReportStatus status;
/// The closure being built for the current session (not yet persisted).
@override final  ClosingReport? currentReport;
/// All previously saved closures, newest first.
 final  List<ClosingReport> _history;
/// All previously saved closures, newest first.
@override@JsonKey() List<ClosingReport> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override final  String? errorMessage;

/// Create a copy of ClosingReportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClosingReportStateCopyWith<_ClosingReportState> get copyWith => __$ClosingReportStateCopyWithImpl<_ClosingReportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClosingReportState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentReport, currentReport) || other.currentReport == currentReport)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentReport,const DeepCollectionEquality().hash(_history),errorMessage);

@override
String toString() {
  return 'ClosingReportState(status: $status, currentReport: $currentReport, history: $history, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ClosingReportStateCopyWith<$Res> implements $ClosingReportStateCopyWith<$Res> {
  factory _$ClosingReportStateCopyWith(_ClosingReportState value, $Res Function(_ClosingReportState) _then) = __$ClosingReportStateCopyWithImpl;
@override @useResult
$Res call({
 ClosingReportStatus status, ClosingReport? currentReport, List<ClosingReport> history, String? errorMessage
});


@override $ClosingReportCopyWith<$Res>? get currentReport;

}
/// @nodoc
class __$ClosingReportStateCopyWithImpl<$Res>
    implements _$ClosingReportStateCopyWith<$Res> {
  __$ClosingReportStateCopyWithImpl(this._self, this._then);

  final _ClosingReportState _self;
  final $Res Function(_ClosingReportState) _then;

/// Create a copy of ClosingReportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? currentReport = freezed,Object? history = null,Object? errorMessage = freezed,}) {
  return _then(_ClosingReportState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClosingReportStatus,currentReport: freezed == currentReport ? _self.currentReport : currentReport // ignore: cast_nullable_to_non_nullable
as ClosingReport?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ClosingReport>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ClosingReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClosingReportCopyWith<$Res>? get currentReport {
    if (_self.currentReport == null) {
    return null;
  }

  return $ClosingReportCopyWith<$Res>(_self.currentReport!, (value) {
    return _then(_self.copyWith(currentReport: value));
  });
}
}

// dart format on
