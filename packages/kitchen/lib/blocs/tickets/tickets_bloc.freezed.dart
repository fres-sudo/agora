// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tickets_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketsEvent {

 String get station;
/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsEventCopyWith<TicketsEvent> get copyWith => _$TicketsEventCopyWithImpl<TicketsEvent>(this as TicketsEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsEvent&&(identical(other.station, station) || other.station == station));
}


@override
int get hashCode => Object.hash(runtimeType,station);

@override
String toString() {
  return 'TicketsEvent(station: $station)';
}


}

/// @nodoc
abstract mixin class $TicketsEventCopyWith<$Res>  {
  factory $TicketsEventCopyWith(TicketsEvent value, $Res Function(TicketsEvent) _then) = _$TicketsEventCopyWithImpl;
@useResult
$Res call({
 String station
});




}
/// @nodoc
class _$TicketsEventCopyWithImpl<$Res>
    implements $TicketsEventCopyWith<$Res> {
  _$TicketsEventCopyWithImpl(this._self, this._then);

  final TicketsEvent _self;
  final $Res Function(TicketsEvent) _then;

/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? station = null,}) {
  return _then(_self.copyWith(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketsEvent].
extension TicketsEventPatterns on TicketsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Advanced value)?  advanced,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Advanced() when advanced != null:
return advanced(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Advanced value)  advanced,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Advanced():
return advanced(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Advanced value)?  advanced,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Advanced() when advanced != null:
return advanced(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String station)?  started,TResult Function( int orderId,  String station,  TicketStatus newStatus)?  advanced,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.station);case _Advanced() when advanced != null:
return advanced(_that.orderId,_that.station,_that.newStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String station)  started,required TResult Function( int orderId,  String station,  TicketStatus newStatus)  advanced,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.station);case _Advanced():
return advanced(_that.orderId,_that.station,_that.newStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String station)?  started,TResult? Function( int orderId,  String station,  TicketStatus newStatus)?  advanced,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.station);case _Advanced() when advanced != null:
return advanced(_that.orderId,_that.station,_that.newStatus);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TicketsEvent {
  const _Started({required this.station});
  

@override final  String station;

/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.station, station) || other.station == station));
}


@override
int get hashCode => Object.hash(runtimeType,station);

@override
String toString() {
  return 'TicketsEvent.started(station: $station)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $TicketsEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@override @useResult
$Res call({
 String station
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? station = null,}) {
  return _then(_Started(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Advanced implements TicketsEvent {
  const _Advanced({required this.orderId, required this.station, required this.newStatus});
  

 final  int orderId;
@override final  String station;
 final  TicketStatus newStatus;

/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvancedCopyWith<_Advanced> get copyWith => __$AdvancedCopyWithImpl<_Advanced>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Advanced&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.station, station) || other.station == station)&&(identical(other.newStatus, newStatus) || other.newStatus == newStatus));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,station,newStatus);

@override
String toString() {
  return 'TicketsEvent.advanced(orderId: $orderId, station: $station, newStatus: $newStatus)';
}


}

/// @nodoc
abstract mixin class _$AdvancedCopyWith<$Res> implements $TicketsEventCopyWith<$Res> {
  factory _$AdvancedCopyWith(_Advanced value, $Res Function(_Advanced) _then) = __$AdvancedCopyWithImpl;
@override @useResult
$Res call({
 int orderId, String station, TicketStatus newStatus
});




}
/// @nodoc
class __$AdvancedCopyWithImpl<$Res>
    implements _$AdvancedCopyWith<$Res> {
  __$AdvancedCopyWithImpl(this._self, this._then);

  final _Advanced _self;
  final $Res Function(_Advanced) _then;

/// Create a copy of TicketsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? station = null,Object? newStatus = null,}) {
  return _then(_Advanced(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,newStatus: null == newStatus ? _self.newStatus : newStatus // ignore: cast_nullable_to_non_nullable
as TicketStatus,
  ));
}


}

/// @nodoc
mixin _$TicketsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsState()';
}


}

/// @nodoc
class $TicketsStateCopyWith<$Res>  {
$TicketsStateCopyWith(TicketsState _, $Res Function(TicketsState) __);
}


/// Adds pattern-matching-related methods to [TicketsState].
extension TicketsStatePatterns on TicketsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( TicketsLoaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case TicketsLoaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( TicketsLoaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case TicketsLoaded():
return loaded(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( TicketsLoaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case TicketsLoaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Ticket> tickets,  String station)?  loaded,TResult Function( String message,  TicketsLoaded? previousState)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case TicketsLoaded() when loaded != null:
return loaded(_that.tickets,_that.station);case _Error() when error != null:
return error(_that.message,_that.previousState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Ticket> tickets,  String station)  loaded,required TResult Function( String message,  TicketsLoaded? previousState)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case TicketsLoaded():
return loaded(_that.tickets,_that.station);case _Error():
return error(_that.message,_that.previousState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Ticket> tickets,  String station)?  loaded,TResult? Function( String message,  TicketsLoaded? previousState)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case TicketsLoaded() when loaded != null:
return loaded(_that.tickets,_that.station);case _Error() when error != null:
return error(_that.message,_that.previousState);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends TicketsState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsState.initial()';
}


}




/// @nodoc


class _Loading extends TicketsState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketsState.loading()';
}


}




/// @nodoc


class TicketsLoaded extends TicketsState {
  const TicketsLoaded({required final  List<Ticket> tickets, required this.station}): _tickets = tickets,super._();
  

 final  List<Ticket> _tickets;
 List<Ticket> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}

 final  String station;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsLoadedCopyWith<TicketsLoaded> get copyWith => _$TicketsLoadedCopyWithImpl<TicketsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsLoaded&&const DeepCollectionEquality().equals(other._tickets, _tickets)&&(identical(other.station, station) || other.station == station));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tickets),station);

@override
String toString() {
  return 'TicketsState.loaded(tickets: $tickets, station: $station)';
}


}

/// @nodoc
abstract mixin class $TicketsLoadedCopyWith<$Res> implements $TicketsStateCopyWith<$Res> {
  factory $TicketsLoadedCopyWith(TicketsLoaded value, $Res Function(TicketsLoaded) _then) = _$TicketsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Ticket> tickets, String station
});




}
/// @nodoc
class _$TicketsLoadedCopyWithImpl<$Res>
    implements $TicketsLoadedCopyWith<$Res> {
  _$TicketsLoadedCopyWithImpl(this._self, this._then);

  final TicketsLoaded _self;
  final $Res Function(TicketsLoaded) _then;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tickets = null,Object? station = null,}) {
  return _then(TicketsLoaded(
tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error extends TicketsState {
  const _Error({required this.message, this.previousState}): super._();
  

 final  String message;
 final  TicketsLoaded? previousState;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.previousState, previousState));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(previousState));

@override
String toString() {
  return 'TicketsState.error(message: $message, previousState: $previousState)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TicketsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, TicketsLoaded? previousState
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousState = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousState: freezed == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as TicketsLoaded?,
  ));
}


}

// dart format on
