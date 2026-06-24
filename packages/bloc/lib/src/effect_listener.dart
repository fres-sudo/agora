import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'effect_bloc.dart';

class EffectListener<B extends EffectBloc<dynamic, dynamic, E>, E>
    extends StatefulWidget {
  const EffectListener({
    super.key,
    required this.onEffect,
    required this.child,
    this.filter,
  });

  final void Function(BuildContext context, E effect) onEffect;
  final bool Function(E effect)? filter;
  final Widget child;

  @override
  State<EffectListener<B, E>> createState() => _EffectListenerState<B, E>();
}

class _EffectListenerState<B extends EffectBloc<dynamic, dynamic, E>, E>
    extends State<EffectListener<B, E>> {
  StreamSubscription<E>? _subscription;
  B? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newBloc = context.read<B>();
    if (newBloc != _bloc) {
      _subscription?.cancel();
      _bloc = newBloc;
      _subscription = _bloc!.effects.listen(
        _onEffect,
        onDone: () => _subscription = null,
        cancelOnError: false,
      );
    }
  }

  void _onEffect(E effect) {
    if (!mounted) return;
    if (widget.filter == null || widget.filter!(effect)) {
      widget.onEffect(context, effect);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
