import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'effect_listener.dart';
import 'effect_bloc.dart';

/// Combines [BlocConsumer] with [EffectListener] so that state changes and
/// side-effects can both be handled from a single widget.
class EffectBlocConsumer<B extends EffectBloc<dynamic, S, E>, S, E> extends StatelessWidget {
  const EffectBlocConsumer({
    super.key,
    required this.builder,
    required this.listener,
    required this.onEffect,
    this.buildWhen,
    this.listenWhen,
    this.filter,
  });

  final Widget Function(BuildContext context, S state) builder;
  final void Function(BuildContext context, S state) listener;
  final void Function(BuildContext context, E effect) onEffect;
  final bool Function(S previous, S current)? buildWhen;
  final bool Function(S previous, S current)? listenWhen;
  final bool Function(E effect)? filter;

  @override
  Widget build(BuildContext context) {
    return EffectListener<B, E>(
      onEffect: onEffect,
      filter: filter,
      child: BlocConsumer<B, S>(
        builder: builder,
        listener: listener,
        buildWhen: buildWhen,
        listenWhen: listenWhen,
      ),
    );
  }
}
