import 'package:agora/pages/setup/_widgets/pin_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:agora/blocs/pin/pin_bloc.dart';

@RoutePage()
class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final List<String> _pin = ['', '', '', ''];
  final List<String> _confirmPin = ['', '', '', ''];
  int _currentIndex = 0;
  bool _isConfirming = false;
  String? _firstPin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PinBloc, PinState>(
        listener:
            (context, state) => switch (state) {
              SettedPinState() => {},
              ErrorPinState() => ShadToaster.of(context).show(
                ShadToast.destructive(
                  title: const Text('Errore'),
                  description: const Text(
                    'Si è verificato un errore inaspettato. Per favore riprovare.',
                  ),
                ),
              ),
              _ => null,
            },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.shield, size: 64),
                  const SizedBox(height: 32),
                  Text(
                    _isConfirming ? 'Conferma PIN' : 'Imposta PIN',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _isConfirming
                          ? "Reinserisci il PIN che hai appena scelto"
                          : 'Scegli un PIN di 4 cifre per mettere al sicuro la tua agora',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 48),
                  PinDots(pin: _isConfirming ? _confirmPin : _pin),
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
    final currentPin = _isConfirming ? _confirmPin : _pin;

    if (_currentIndex < 4) {
      setState(() {
        currentPin[_currentIndex] = number;
        _currentIndex++;
      });

      if (_currentIndex == 4) {
        if (!_isConfirming) {
          _firstPin = currentPin.join();
          setState(() {
            _isConfirming = true;
            _currentIndex = 0;
          });
        } else {
          final confirmPinString = _confirmPin.join();
          if (_firstPin == confirmPinString) {
            context.read<PinBloc>().add(PinEvent.set(pin: _firstPin!));
          } else {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: const Text('Errore'),
                description: const Text(
                  'I PIN non sono uguali. Per favore riprovare.',
                ),
              ),
            );
            _resetToFirstPin();
          }
        }
      }
    }
  }

  void _onDeletePressed() {
    final currentPin = _isConfirming ? _confirmPin : _pin;

    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        currentPin[_currentIndex] = '';
      });
    }
  }

  void _resetToFirstPin() {
    setState(() {
      _pin.fillRange(0, 4, '');
      _confirmPin.fillRange(0, 4, '');
      _currentIndex = 0;
      _isConfirming = false;
      _firstPin = null;
    });
  }
}
