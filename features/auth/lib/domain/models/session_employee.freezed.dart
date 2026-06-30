// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_employee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionEmployee {

 int get id; String get name; String get role;
/// Create a copy of SessionEmployee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEmployeeCopyWith<SessionEmployee> get copyWith => _$SessionEmployeeCopyWithImpl<SessionEmployee>(this as SessionEmployee, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEmployee&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,role);

@override
String toString() {
  return 'SessionEmployee(id: $id, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class $SessionEmployeeCopyWith<$Res>  {
  factory $SessionEmployeeCopyWith(SessionEmployee value, $Res Function(SessionEmployee) _then) = _$SessionEmployeeCopyWithImpl;
@useResult
$Res call({
 int id, String name, String role
});




}
/// @nodoc
class _$SessionEmployeeCopyWithImpl<$Res>
    implements $SessionEmployeeCopyWith<$Res> {
  _$SessionEmployeeCopyWithImpl(this._self, this._then);

  final SessionEmployee _self;
  final $Res Function(SessionEmployee) _then;

/// Create a copy of SessionEmployee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionEmployee].
extension SessionEmployeePatterns on SessionEmployee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionEmployee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionEmployee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionEmployee value)  $default,){
final _that = this;
switch (_that) {
case _SessionEmployee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionEmployee value)?  $default,){
final _that = this;
switch (_that) {
case _SessionEmployee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionEmployee() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String role)  $default,) {final _that = this;
switch (_that) {
case _SessionEmployee():
return $default(_that.id,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String role)?  $default,) {final _that = this;
switch (_that) {
case _SessionEmployee() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _SessionEmployee extends SessionEmployee {
  const _SessionEmployee({required this.id, required this.name, required this.role}): super._();
  

@override final  int id;
@override final  String name;
@override final  String role;

/// Create a copy of SessionEmployee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionEmployeeCopyWith<_SessionEmployee> get copyWith => __$SessionEmployeeCopyWithImpl<_SessionEmployee>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionEmployee&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,role);

@override
String toString() {
  return 'SessionEmployee(id: $id, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class _$SessionEmployeeCopyWith<$Res> implements $SessionEmployeeCopyWith<$Res> {
  factory _$SessionEmployeeCopyWith(_SessionEmployee value, $Res Function(_SessionEmployee) _then) = __$SessionEmployeeCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String role
});




}
/// @nodoc
class __$SessionEmployeeCopyWithImpl<$Res>
    implements _$SessionEmployeeCopyWith<$Res> {
  __$SessionEmployeeCopyWithImpl(this._self, this._then);

  final _SessionEmployee _self;
  final $Res Function(_SessionEmployee) _then;

/// Create a copy of SessionEmployee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,}) {
  return _then(_SessionEmployee(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
