// These tests deliberately drive the SUT's effect stream by calling the
// @protected emitEffect from the test body to exercise buffering/ordering.
// ignore_for_file: invalid_use_of_protected_member
import 'package:bloc_exports/src/effect_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestEvent {}

class _TestBloc extends EffectBloc<_TestEvent, int, String> {
  _TestBloc() : super(0) {
    on<_TestEvent>((event, emit) => emitEffect('effect'));
  }
}

void main() {
  group('EffectBloc', () {
    late _TestBloc bloc;

    setUp(() {
      bloc = _TestBloc();
    });

    tearDown(() async {
      if (!bloc.isClosed) await bloc.close();
    });

    // H1: the effects stream is a broadcast StreamController, so it does not
    // buffer — effects emitted while no listener is attached are dropped.
    test(
      'no buffering (H1): effect emitted before subscribe is dropped',
      () async {
        bloc.emitEffect('dropped');

        final received = <String>[];
        final sub = bloc.effects.listen(received.add);

        await pumpEventQueue();

        expect(received, isEmpty);
        await sub.cancel();
      },
    );

    test('ordered delivery: three effects arrive in emission order', () async {
      final received = <String>[];
      final sub = bloc.effects.listen(received.add);

      bloc.emitEffect('first');
      bloc.emitEffect('second');
      bloc.emitEffect('third');

      await pumpEventQueue();

      expect(received, ['first', 'second', 'third']);
      await sub.cancel();
    });

    test(
      'no-op after close: emitEffect after bloc.close() does not throw and emits nothing',
      () async {
        final received = <String>[];
        final sub = bloc.effects.listen(received.add);

        await bloc.close();
        bloc.emitEffect('post-close');

        await pumpEventQueue();

        expect(received, isEmpty);
        await sub.cancel();
      },
    );

    test('close closes stream: bloc.isClosed is true after close()', () async {
      await bloc.close();
      expect(bloc.isClosed, isTrue);
    });

    // H3 canonical pattern: subscribe BEFORE adding the event.
    test(
      'subscribe-before-add (H3): effect received when listener attaches before event',
      () async {
        final received = <String>[];
        final sub = bloc.effects.listen(received.add);

        bloc.add(_TestEvent());
        await pumpEventQueue();

        expect(received, ['effect']);
        await sub.cancel();
      },
    );
  });
}
