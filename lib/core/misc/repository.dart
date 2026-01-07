import 'package:agora/core/exceptions/repository_exception.dart';
import 'package:talker/talker.dart';
import "result.dart";

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
    } catch (error, stack) {
      logger?.handle(
        error,
        stack,
        '[Repository] Error during $operation - $error',
      );
      // await Sentry.captureException(error, stackTrace: stack);
      return Result.error(
        RepositoryException(error.toString(), stack.toString()),
      );
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
    } catch (error, stack) {
      logger?.handle(error, stack, '[Repository] $operation');
      return Result.error(
        RepositoryException(error.toString(), stack.toString()),
      );
    }
  }
}

extension RepositoryStream<T> on Stream<T> {
  Stream<T> safeCode(Talker? logger) =>
      handleError((Object error, StackTrace stack) async {
        logger?.error('[Repository] Stream error: ', error, stack);
        // await Sentry.captureException(error, stackTrace: stack);
      });
}
