import 'dart:async';

import 'package:errors/errors.dart';
import 'package:result/result.dart';
import 'package:test/test.dart';

class _TestRepository extends Repository {
  const _TestRepository();
}

void main() {
  group('Repository.safe', () {
    final repository = const _TestRepository();

    test('returns Ok with the value on success', () async {
      final result = await repository.safe('op', () async => 42);

      expect(result.isSuccess, isTrue);
      result.when(
        success: (value) => expect(value, 42),
        error: (_) => fail('expected success'),
      );
    });

    test(
      'converts an expected Exception into an Err result instead of swallowing it',
      () async {
        final result = await repository.safe<int>('op', () async {
          throw const FormatException('bad input');
        });

        expect(result.isError, isTrue);
        var handled = false;
        result.when(
          success: (_) => fail('expected an error result'),
          error: (error) {
            handled = true;
            expect(error, isA<RepositoryException>());
            expect(error.toString(), contains('bad input'));
          },
        );
        expect(
          handled,
          isTrue,
          reason: 'onError handler must fire, not be dead code',
        );
      },
    );

    test(
      'a manually thrown RepositoryException is surfaced as an Err result',
      () async {
        final result = await repository.safe<int>('op', () async {
          throw RepositoryException('Invalid PIN');
        });

        expect(result.isError, isTrue);
        result.when(
          success: (_) => fail('expected an error result'),
          error: (error) => expect(error.toString(), 'Invalid PIN'),
        );
      },
    );

    test(
      'programming bugs (Error subtypes) are rethrown instead of being silently downgraded',
      () async {
        expect(
          () => repository.safe<int>('op', () async {
            throw StateError('unexpected null');
          }),
          throwsA(isA<StateError>()),
        );
      },
    );
  });

  group('Repository.safeResult', () {
    final repository = const _TestRepository();

    test('passes through an Ok result unchanged', () async {
      final result = await repository.safeResult(
        'op',
        () async => const Result.ok(1),
      );
      expect(result.isSuccess, isTrue);
    });

    test('converts a thrown Exception into an Err result', () async {
      final result = await repository.safeResult<int>('op', () async {
        throw const FormatException('nope');
      });

      expect(result.isError, isTrue);
    });

    test('rethrows programming bugs instead of swallowing them', () async {
      expect(
        () => repository.safeResult<int>('op', () async {
          throw ArgumentError('bad arg');
        }),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Stream.safeCode', () {
    test('data events pass through untouched', () async {
      final stream = Stream.fromIterable([1, 2, 3]).safeCode(null);
      expect(await stream.toList(), [1, 2, 3]);
    });

    test(
      'propagates stream errors downstream so onError handlers actually fire (regression for #12)',
      () async {
        final controller = StreamController<int>();
        final safeStream = controller.stream.safeCode(null);

        Object? receivedError;
        final done = Completer<void>();
        safeStream.listen(
          (_) {},
          onError: (error) {
            receivedError = error;
          },
          onDone: done.complete,
        );

        controller.addError(Exception('stream boom'));
        await controller.close();
        await done.future;

        expect(
          receivedError,
          isNotNull,
          reason:
              'onError must be invoked - previously safeCode() fully '
              'absorbed the error and this handler was dead code',
        );
        expect(receivedError.toString(), contains('stream boom'));
      },
    );
  });
}
