import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class EffectBloc<Event, State, Effect> extends Bloc<Event, State> {
  EffectBloc(super.initialState);

  // Single-subscription (buffered): effects emitted before the listener subscribes are delivered when it attaches.
  final StreamController<Effect> _effects = StreamController<Effect>();

  Stream<Effect> get effects => _effects.stream;

  @protected
  void emitEffect(Effect effect) {
    if (!_effects.isClosed) _effects.add(effect);
  }

  @override
  Future<void> close() async {
    // Await super.close() first to stop event processing before closing the effects stream.
    // This prevents handlers from calling emitEffect() during teardown.
    // unawaited on _effects.close(): awaiting a single-subscription controller without an
    // active consumer deadlocks (the done event is never consumed).
    await super.close();
    if (!_effects.isClosed) {
      unawaited(_effects.close());
    }
  }
}
