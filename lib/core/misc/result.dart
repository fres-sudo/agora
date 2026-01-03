/// Utility class to wrap result data
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error._;

  /// Returns the [Ok] value, or throws the contained [Exception] if this is an [Error].
  ///
  /// This is useful in places where failing-fast is desired (e.g. tests).
  T unwrap() => switch (this) {
        Ok<T>(:final value) => value,
        Error<T>(:final error) => throw error,
      };
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

extension ResultFutureX<T> on Future<Result<T>> {
  Future<T> unwrapAsync() async => switch (await this) {
        Ok<T>(:final value) => value,
        Error<T>(:final error) => throw error,
      };
}

extension ResultX<T> on Result<T> {
  void when({
    required void Function(T value) success,
    required void Function(Exception error) error,
  }) =>
      switch (this) {
        Ok<T>(:final value) => success(value),
        Error<T>(error: final err) => error(err),
      };

  bool get isSuccess => this is Ok<T>;
  bool get isError => this is Error<T>;
}
