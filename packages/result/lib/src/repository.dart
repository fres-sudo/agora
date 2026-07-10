import 'package:errors/errors.dart';
import 'package:talker/talker.dart';
// `Error` is hidden because this package also defines a sealed `Error<T>`
// (the failure case of `Result<T>`) which would otherwise shadow
// `dart:core`'s `Error` class used below for `Error.throwWithStackTrace`.
import 'package:result/result.dart' hide Error;

abstract class Repository {
  const Repository([this.logger]);

  final Talker? logger;

  /// Wraps calls to standardize logging + reporting.
  ///
  /// - [operation] should be a short identifier like `"get_profile"` or
  ///   `"[UsersService] fetchCurrentUser"`.
  Future<Result<T>> safe<T>(
    String operation,
    Future<T> Function() block,
  ) async {
    try {
      logger?.debug('[Repository] Calling $operation');
      final value = await block();
      final result = Result.ok(value);
      logger?.debug('[Repository] Success $operation - result: $result');
      return result;
    } on Exception catch (error, stack) {
      // Only `Exception`s are treated as expected, recoverable repository
      // failures and converted into an `Err` result. `Error`s (e.g.
      // `TypeError`, `NoSuchMethodError`, `StateError`) indicate programming
      // bugs and are intentionally left uncaught below, so they surface as a
      // real crash instead of being silently downgraded into a generic
      // failure that's indistinguishable from an expected one.
      logger?.handle(
        error,
        stack,
        '[Repository] Error during $operation - $error',
      );
      // await Sentry.captureException(error, stackTrace: stack);
      return Result.error(
        RepositoryException(error.toString(), stack.toString()),
      );
    } catch (error, stack) {
      // Unexpected (non-Exception) error: log it for observability/crash
      // reporting, then rethrow so it isn't silently swallowed.
      logger?.handle(
        error,
        stack,
        '[Repository] Unexpected error during $operation - $error',
      );
      rethrow;
    }
  }

  /// Like [safe], but for code that already returns `Result<T>`.
  ///
  /// Useful when composing multiple `Result`-returning helpers without unwrapping.
  Future<Result<T>> safeResult<T>(
    String operation,
    Future<Result<T>> Function() block,
  ) async {
    try {
      logger?.debug('[Repository] $operation');
      final result = await block();
      logger?.debug('[Repository] $operation result: $result');
      return result;
    } on Exception catch (error, stack) {
      logger?.handle(error, stack, '[Repository] $operation');
      return Result.error(
        RepositoryException(error.toString(), stack.toString()),
      );
    } catch (error, stack) {
      logger?.handle(
        error,
        stack,
        '[Repository] Unexpected error - $operation',
      );
      rethrow;
    }
  }
}

extension RepositoryStream<T> on Stream<T> {
  /// Logs stream errors and lets them continue to propagate downstream.
  ///
  /// Previously this used `handleError` without rethrowing, which fully
  /// absorbed every error emitted by the source stream: subscribers'
  /// `onError` callbacks (e.g. in blocs/cubits listening to
  /// `watchAll...()` streams) were never invoked, making that error
  /// handling dead code. Rethrowing preserves the original error and
  /// stack trace so it still reaches downstream listeners after being
  /// logged here.
  Stream<T> safeCode(Talker? logger) =>
      handleError((Object error, StackTrace stack) {
        logger?.error('[Repository] Stream error: ', error, stack);
        // await Sentry.captureException(error, stackTrace: stack);
        Error.throwWithStackTrace(error, stack);
      });
}
