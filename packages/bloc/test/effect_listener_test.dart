// These tests deliberately drive the SUT's effect stream by calling the
// @protected emitEffect from the test body to exercise the listener.
// ignore_for_file: invalid_use_of_protected_member
import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_app.dart';

// Minimal concrete BLoC used across all test cases.
class _TestEvent {}

class _TestBloc extends EffectBloc<_TestEvent, int, String> {
  _TestBloc() : super(0) {
    on<_TestEvent>((event, emit) => emitEffect('effect'));
  }
}

// Closes the bloc safely from an addTearDown callback.
//
// Unmounts any EffectListener still in the tree first so dispose() cancels
// the subscription before close() runs. close() fires unawaited on the
// internal StreamController — no drain, no blocking.
Future<void> _tearDownBloc(WidgetTester tester, _TestBloc bloc) async {
  if (bloc.isClosed) return;
  await tester.pumpWidget(const SizedBox.shrink());
  await bloc.close();
}

void main() {
  group('EffectListener', () {
    // H2: the mount-guard (`if (!mounted) return`) inside _onEffect prevents
    // the callback from firing after the widget is removed from the tree.
    testWidgets('mount-guard (H2): onEffect not called after widget unmounted', (
      tester,
    ) async {
      // Arrange
      final bloc = _TestBloc();
      addTearDown(() => _tearDownBloc(tester, bloc));

      final received = <String>[];

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectListener<_TestBloc, String>(
            onEffect: (_, effect) => received.add(effect),
            child: const SizedBox.shrink(),
          ),
        ),
        wrapWithScaffold: false,
      );

      // Act: emit an effect and pump twice — first pump flushes the stream
      // microtask scheduling, second pump delivers the callback to the widget.
      bloc.emitEffect('pre-unmount');
      await tester.pump();
      await tester.pump();

      expect(received, ['pre-unmount']);

      // Remove the widget from the tree — dispose() cancels the subscription.
      await tester.pumpWidget(const SizedBox.shrink());

      // Emit another effect after unmount — should be ignored.
      bloc.emitEffect('post-unmount');
      await tester.pump();
      await tester.pump();

      // Assert: callback count stays at 1.
      expect(received, ['pre-unmount']);
    });

    testWidgets(
      'dispose cancels subscription: no crash after widget removed and effect emitted',
      (tester) async {
        // Arrange
        final bloc = _TestBloc();
        addTearDown(() => _tearDownBloc(tester, bloc));

        await tester.pumpApp(
          BlocProvider.value(
            value: bloc,
            child: EffectListener<_TestBloc, String>(
              onEffect: (_, effect) {},
              child: const SizedBox.shrink(),
            ),
          ),
          wrapWithScaffold: false,
        );

        // Act: remove the widget (triggers dispose + subscription cancel).
        await tester.pumpWidget(const SizedBox.shrink());

        // Assert: emitting after dispose does not throw.
        expect(() {
          bloc.emitEffect('after-dispose');
        }, returnsNormally);

        await tester.pump();
      },
    );

    testWidgets('filter suppresses non-matching effects', (tester) async {
      // Arrange
      final bloc = _TestBloc();
      addTearDown(() => _tearDownBloc(tester, bloc));

      final received = <String>[];

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectListener<_TestBloc, String>(
            filter: (effect) => effect == 'pass',
            onEffect: (_, effect) => received.add(effect),
            child: const SizedBox.shrink(),
          ),
        ),
        wrapWithScaffold: false,
      );

      // Act: emit one effect that should be suppressed, one that should pass.
      bloc.emitEffect('fail');
      bloc.emitEffect('pass');
      await tester.pump();
      await tester
          .pump(); // drain residual microtasks from the second stream event

      // Assert: only 'pass' was delivered.
      expect(received, ['pass']);
    });

    testWidgets(
      'buffered effect: effect emitted before widget built is delivered after initState subscribe',
      (tester) async {
        // Arrange: emit BEFORE the widget is pumped so the effect is buffered
        // in the single-subscription StreamController.
        final bloc = _TestBloc();
        addTearDown(() => _tearDownBloc(tester, bloc));

        bloc.emitEffect('buffered');

        final received = <String>[];

        // Act: pump the listener — initState subscribes and drains the buffer.
        await tester.pumpApp(
          BlocProvider.value(
            value: bloc,
            child: EffectListener<_TestBloc, String>(
              onEffect: (_, effect) => received.add(effect),
              child: const SizedBox.shrink(),
            ),
          ),
          wrapWithScaffold: false,
        );

        await tester.pump();

        // Assert: the buffered effect was delivered.
        expect(received, ['buffered']);
      },
    );
  });
}
