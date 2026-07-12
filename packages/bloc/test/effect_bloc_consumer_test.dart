// These tests deliberately drive the SUT's effect stream by calling the
// @protected emitEffect from the test body to exercise the consumer.
// ignore_for_file: invalid_use_of_protected_member
import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_app.dart';

class _Increment {}

class _ConsumerBloc extends EffectBloc<_Increment, int, String> {
  _ConsumerBloc() : super(0) {
    on<_Increment>((event, emit) {
      emit(state + 1);
      emitEffect('incremented');
    });
  }
}

Future<void> _tearDown(WidgetTester tester, _ConsumerBloc bloc) async {
  if (bloc.isClosed) return;
  await tester.pumpWidget(const SizedBox.shrink());
  await bloc.close();
}

void main() {
  group('EffectBlocConsumer', () {
    testWidgets('builder receives initial state', (tester) async {
      final bloc = _ConsumerBloc();
      addTearDown(() => _tearDown(tester, bloc));

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<_ConsumerBloc, int, String>(
            builder: (context, state) => Text('$state'),
            listener: (context, state) {},
            onEffect: (context, effect) {},
          ),
        ),
        wrapWithScaffold: false,
      );

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('builder rebuilds on state change', (tester) async {
      final bloc = _ConsumerBloc();
      addTearDown(() => _tearDown(tester, bloc));

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<_ConsumerBloc, int, String>(
            builder: (context, state) => Text('$state'),
            listener: (context, state) {},
            onEffect: (context, effect) {},
          ),
        ),
        wrapWithScaffold: false,
      );

      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('listener receives state changes', (tester) async {
      final bloc = _ConsumerBloc();
      addTearDown(() => _tearDown(tester, bloc));
      final states = <int>[];

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<_ConsumerBloc, int, String>(
            builder: (context, state) => const SizedBox.shrink(),
            listener: (context, state) => states.add(state),
            onEffect: (context, effect) {},
          ),
        ),
        wrapWithScaffold: false,
      );

      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();

      expect(states, [1]);
    });

    testWidgets('onEffect receives effects emitted by the bloc', (
      tester,
    ) async {
      final bloc = _ConsumerBloc();
      addTearDown(() => _tearDown(tester, bloc));
      final effects = <String>[];

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<_ConsumerBloc, int, String>(
            builder: (context, state) => const SizedBox.shrink(),
            listener: (context, state) {},
            onEffect: (context, effect) => effects.add(effect),
          ),
        ),
        wrapWithScaffold: false,
      );

      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();

      expect(effects, ['incremented']);
    });

    testWidgets('filter suppresses non-matching effects', (tester) async {
      final bloc = _ConsumerBloc();
      addTearDown(() => _tearDown(tester, bloc));
      final effects = <String>[];

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<_ConsumerBloc, int, String>(
            filter: (effect) => effect == 'other',
            builder: (context, state) => const SizedBox.shrink(),
            listener: (context, state) {},
            onEffect: (context, effect) => effects.add(effect),
          ),
        ),
        wrapWithScaffold: false,
      );

      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();

      // 'incremented' does not match 'other' so it is filtered out.
      expect(effects, isEmpty);
    });

    testWidgets('buildWhen controls when builder is called', (tester) async {
      final bloc = _ConsumerBloc();
      addTearDown(() => _tearDown(tester, bloc));
      var buildCount = 0;

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<_ConsumerBloc, int, String>(
            buildWhen: (prev, curr) => curr.isEven,
            builder: (context, state) {
              buildCount++;
              return Text('$state');
            },
            listener: (context, state) {},
            onEffect: (context, effect) {},
          ),
        ),
        wrapWithScaffold: false,
      );

      // Initial build: state=0 (even) → builds.
      expect(buildCount, 1);

      // state → 1 (odd) → buildWhen returns false → no rebuild.
      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();
      expect(buildCount, 1);

      // state → 2 (even) → buildWhen returns true → rebuilds.
      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();
      expect(buildCount, 2);
    });

    testWidgets('listenWhen controls when listener is called', (tester) async {
      final bloc = _ConsumerBloc();
      addTearDown(() => _tearDown(tester, bloc));
      final states = <int>[];

      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<_ConsumerBloc, int, String>(
            listenWhen: (prev, curr) => curr.isEven,
            builder: (context, state) => const SizedBox.shrink(),
            listener: (context, state) => states.add(state),
            onEffect: (context, effect) {},
          ),
        ),
        wrapWithScaffold: false,
      );

      // state → 1 (odd) → listenWhen false → not added.
      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();
      expect(states, isEmpty);

      // state → 2 (even) → listenWhen true → added.
      bloc.add(_Increment());
      await tester.pump();
      await tester.pump();
      expect(states, [2]);
    });

    testWidgets(
      'direct emitEffect (before add) is dropped, not delivered via onEffect',
      (tester) async {
        final bloc = _ConsumerBloc();
        addTearDown(() => _tearDown(tester, bloc));

        bloc.emitEffect('dropped');

        final effects = <String>[];

        await tester.pumpApp(
          BlocProvider.value(
            value: bloc,
            child: EffectBlocConsumer<_ConsumerBloc, int, String>(
              builder: (context, state) => const SizedBox.shrink(),
              listener: (context, state) {},
              onEffect: (context, effect) => effects.add(effect),
            ),
          ),
          wrapWithScaffold: false,
        );

        await tester.pump();

        expect(effects, isEmpty);
      },
    );
  });
}
