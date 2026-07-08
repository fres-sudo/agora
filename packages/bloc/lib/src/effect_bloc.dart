import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class EffectBloc<Event, State, Effect> extends Bloc<Event, State> {
  EffectBloc(super.initialState);

  // Broadcast: the bloc typically outlives the widgets that consume it, so its
  // effects stream must tolerate being (re-)listened to every time a listener
  // widget mounts. A single-subscription controller can only be listened to
  // once for its entire lifetime — even after the first subscription is
  // cancelled — which crashes with "Stream has already been listened to" when
  // a page hosting an EffectListener is popped and pushed again.
  //
  // Trade-off: effects emitted while no listener is attached are dropped rather
  // than buffered. That is fine for UI side-effects (snackbars, navigation),
  // which are only meaningful when a view is present to react to them.
  final StreamController<Effect> _effects =
      StreamController<Effect>.broadcast();

  Stream<Effect> get effects => _effects.stream;

  @protected
  void emitEffect(Effect effect) {
    if (!_effects.isClosed) _effects.add(effect);
  }

  @override
  Future<void> close() async {
    // Await super.close() first to stop event processing before closing the effects stream.
    // This prevents handlers from calling emitEffect() during teardown.
    await super.close();
    if (!_effects.isClosed) {
      unawaited(_effects.close());
    }
  }
}
