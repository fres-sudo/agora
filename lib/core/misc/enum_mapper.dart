import 'package:pine/pine.dart';

abstract class EnumMapper<R, E> extends Mapper<R?, E?> {
  EnumMapper(this.fromValues)
      // Invert map: swap keys/values for reverse mapping
      : toValues = fromValues.map((key, value) => MapEntry(value, key));
  final Map<R, E> fromValues;
  final Map<E, R> toValues;

  @override
  E? from(R? from) => fromValues[from];

  @override
  R? to(E? to) => toValues[to];
}
