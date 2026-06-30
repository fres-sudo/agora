// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Employee {

 int get id; String get name; String get pin; EmployeeRole get role; bool get isActive; int get hourlyRateCents; String? get avatarUrl; DateTime? get createdAt;
/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeCopyWith<Employee> get copyWith => _$EmployeeCopyWithImpl<Employee>(this as Employee, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Employee&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hourlyRateCents, hourlyRateCents) || other.hourlyRateCents == hourlyRateCents)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,pin,role,isActive,hourlyRateCents,avatarUrl,createdAt);

@override
String toString() {
  return 'Employee(id: $id, name: $name, pin: $pin, role: $role, isActive: $isActive, hourlyRateCents: $hourlyRateCents, avatarUrl: $avatarUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EmployeeCopyWith<$Res>  {
  factory $EmployeeCopyWith(Employee value, $Res Function(Employee) _then) = _$EmployeeCopyWithImpl;
@useResult
$Res call({
 int id, String name, String pin, EmployeeRole role, bool isActive, int hourlyRateCents, String? avatarUrl, DateTime? createdAt
});




}
/// @nodoc
class _$EmployeeCopyWithImpl<$Res>
    implements $EmployeeCopyWith<$Res> {
  _$EmployeeCopyWithImpl(this._self, this._then);

  final Employee _self;
  final $Res Function(Employee) _then;

/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pin = null,Object? role = null,Object? isActive = null,Object? hourlyRateCents = null,Object? avatarUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as EmployeeRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hourlyRateCents: null == hourlyRateCents ? _self.hourlyRateCents : hourlyRateCents // ignore: cast_nullable_to_non_nullable
as int,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Employee].
extension EmployeePatterns on Employee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Employee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Employee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Employee value)  $default,){
final _that = this;
switch (_that) {
case _Employee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Employee value)?  $default,){
final _that = this;
switch (_that) {
case _Employee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String pin,  EmployeeRole role,  bool isActive,  int hourlyRateCents,  String? avatarUrl,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Employee() when $default != null:
return $default(_that.id,_that.name,_that.pin,_that.role,_that.isActive,_that.hourlyRateCents,_that.avatarUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String pin,  EmployeeRole role,  bool isActive,  int hourlyRateCents,  String? avatarUrl,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Employee():
return $default(_that.id,_that.name,_that.pin,_that.role,_that.isActive,_that.hourlyRateCents,_that.avatarUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String pin,  EmployeeRole role,  bool isActive,  int hourlyRateCents,  String? avatarUrl,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Employee() when $default != null:
return $default(_that.id,_that.name,_that.pin,_that.role,_that.isActive,_that.hourlyRateCents,_that.avatarUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Employee extends Employee {
  const _Employee({required this.id, required this.name, required this.pin, required this.role, required this.isActive, this.hourlyRateCents = 0, this.avatarUrl, this.createdAt}): super._();
  

@override final  int id;
@override final  String name;
@override final  String pin;
@override final  EmployeeRole role;
@override final  bool isActive;
@override@JsonKey() final  int hourlyRateCents;
@override final  String? avatarUrl;
@override final  DateTime? createdAt;

/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeCopyWith<_Employee> get copyWith => __$EmployeeCopyWithImpl<_Employee>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Employee&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hourlyRateCents, hourlyRateCents) || other.hourlyRateCents == hourlyRateCents)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,pin,role,isActive,hourlyRateCents,avatarUrl,createdAt);

@override
String toString() {
  return 'Employee(id: $id, name: $name, pin: $pin, role: $role, isActive: $isActive, hourlyRateCents: $hourlyRateCents, avatarUrl: $avatarUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EmployeeCopyWith<$Res> implements $EmployeeCopyWith<$Res> {
  factory _$EmployeeCopyWith(_Employee value, $Res Function(_Employee) _then) = __$EmployeeCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String pin, EmployeeRole role, bool isActive, int hourlyRateCents, String? avatarUrl, DateTime? createdAt
});




}
/// @nodoc
class __$EmployeeCopyWithImpl<$Res>
    implements _$EmployeeCopyWith<$Res> {
  __$EmployeeCopyWithImpl(this._self, this._then);

  final _Employee _self;
  final $Res Function(_Employee) _then;

/// Create a copy of Employee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pin = null,Object? role = null,Object? isActive = null,Object? hourlyRateCents = null,Object? avatarUrl = freezed,Object? createdAt = freezed,}) {
  return _then(_Employee(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as EmployeeRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hourlyRateCents: null == hourlyRateCents ? _self.hourlyRateCents : hourlyRateCents // ignore: cast_nullable_to_non_nullable
as int,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
