import 'package:agora/pages/setup/_widgets/pin_widgets.dart';
import 'package:agora/routes/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:agora/blocs/pin/pin_bloc.dart';

@RoutePage()
class PinInputPage extends StatefulWidget {
  const PinInputPage({super.key});

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  final List<String> _pin = ['', '', '', ''];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PinBloc, PinState>(
        listener:
            (context, state) => switch (state) {
              ValidPinState() => context.router.replace(const RootRoute()),
              InvalidPinState() => {
                ShadToaster.of(context).show(
                  ShadToast.destructive(
                    title: const Text('Errore'),
                    description: const Text(
                      'Il PIN è errato. Per favore riprovare.',
                    ),
                  ),
                ),
                setState(() {
                  for (int i = 0; i < _pin.length; i++) {
                    _pin[i] = "";
                  }
                  _currentIndex = 0;
                }),
              },
              _ => null,
            },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.lock, size: 64),
                  const SizedBox(height: 32),
                  Text(
                    'Inserisci il PIN',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 48),
                  PinDots(pin: _pin),
                  const SizedBox(height: 48),
                  PinKeypad(
                    onNumberPressed: _onNumberPressed,
                    onDeletePressed: _onDeletePressed,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onNumberPressed(String number) {
    if (_currentIndex < 4) {
      setState(() {
        _pin[_currentIndex] = number;
        _currentIndex++;
      });

      if (_currentIndex == 4) {
        final pinString = _pin.join();
        context.read<PinBloc>().add(PinEvent.validate(pin: pinString));
      }
    }
  }

  void _onDeletePressed() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pin[_currentIndex] = '';
      });
    }
  }

  void _clearPin() {
    setState(() {
      _pin.fillRange(0, 4, '');
      _currentIndex = 0;
    });
  }
}
