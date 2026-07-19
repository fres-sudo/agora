// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Combo {

 int get id; String get name; int get priceCents;// Flat price, overrides the sum of parts
 bool get isEnabled; List<ComboItem> get items;
/// Create a copy of Combo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComboCopyWith<Combo> get copyWith => _$ComboCopyWithImpl<Combo>(this as Combo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Combo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceCents,isEnabled,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'Combo(id: $id, name: $name, priceCents: $priceCents, isEnabled: $isEnabled, items: $items)';
}


}

/// @nodoc
abstract mixin class $ComboCopyWith<$Res>  {
  factory $ComboCopyWith(Combo value, $Res Function(Combo) _then) = _$ComboCopyWithImpl;
@useResult
$Res call({
 int id, String name, int priceCents, bool isEnabled, List<ComboItem> items
});




}
/// @nodoc
class _$ComboCopyWithImpl<$Res>
    implements $ComboCopyWith<$Res> {
  _$ComboCopyWithImpl(this._self, this._then);

  final Combo _self;
  final $Res Function(Combo) _then;

/// Create a copy of Combo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceCents = null,Object? isEnabled = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ComboItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Combo].
extension ComboPatterns on Combo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Combo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Combo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Combo value)  $default,){
final _that = this;
switch (_that) {
case _Combo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Combo value)?  $default,){
final _that = this;
switch (_that) {
case _Combo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int priceCents,  bool isEnabled,  List<ComboItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Combo() when $default != null:
return $default(_that.id,_that.name,_that.priceCents,_that.isEnabled,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int priceCents,  bool isEnabled,  List<ComboItem> items)  $default,) {final _that = this;
switch (_that) {
case _Combo():
return $default(_that.id,_that.name,_that.priceCents,_that.isEnabled,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int priceCents,  bool isEnabled,  List<ComboItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Combo() when $default != null:
return $default(_that.id,_that.name,_that.priceCents,_that.isEnabled,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Combo extends Combo {
  const _Combo({required this.id, required this.name, required this.priceCents, this.isEnabled = true, final  List<ComboItem> items = const []}): _items = items,super._();
  

@override final  int id;
@override final  String name;
@override final  int priceCents;
// Flat price, overrides the sum of parts
@override@JsonKey() final  bool isEnabled;
 final  List<ComboItem> _items;
@override@JsonKey() List<ComboItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Combo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComboCopyWith<_Combo> get copyWith => __$ComboCopyWithImpl<_Combo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Combo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceCents,isEnabled,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'Combo(id: $id, name: $name, priceCents: $priceCents, isEnabled: $isEnabled, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ComboCopyWith<$Res> implements $ComboCopyWith<$Res> {
  factory _$ComboCopyWith(_Combo value, $Res Function(_Combo) _then) = __$ComboCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int priceCents, bool isEnabled, List<ComboItem> items
});




}
/// @nodoc
class __$ComboCopyWithImpl<$Res>
    implements _$ComboCopyWith<$Res> {
  __$ComboCopyWithImpl(this._self, this._then);

  final _Combo _self;
  final $Res Function(_Combo) _then;

/// Create a copy of Combo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceCents = null,Object? isEnabled = null,Object? items = null,}) {
  return _then(_Combo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ComboItem>,
  ));
}


}

// dart format on
