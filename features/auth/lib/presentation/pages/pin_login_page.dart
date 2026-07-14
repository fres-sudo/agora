import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:auth_session/models/session_employee.dart';
import 'package:auth_session/repositories/auth_repository.dart';
import 'package:auth_session/blocs/session_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  List<SessionEmployee> _employees = [];
  SessionEmployee? _selected;
  String _pin = '';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final repo = context.read<AuthRepository>();
    final employees = await repo.getActiveEmployees();
    if (mounted) setState(() => _employees = employees);
  }

  void _selectEmployee(SessionEmployee emp) {
    setState(() {
      _selected = emp;
      _pin = '';
      _error = null;
    });
  }

  void _onDigit(String digit) {
    if (_pin.length >= 6) return;
    setState(() {
      _pin += digit;
      _error = null;
    });
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _onConfirm() async {
    if (_selected == null || _pin.length < 4) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    await context.read<SessionCubit>().loginWithPin(_selected!.id, _pin);
    if (!mounted) return;
    final state = context.read<SessionCubit>().state;
    if (state is SessionError) {
      setState(() {
        _loading = false;
        _error = 'Incorrect PIN. Please try again.';
        _pin = '';
      });
    }
    // On success, the app-level SessionListener handles navigation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.tokens.spaceXl),
              child: _selected == null
                  ? _EmployeeSelector(
                      employees: _employees,
                      onSelect: _selectEmployee,
                    )
                  : _PinPad(
                      employee: _selected!,
                      pin: _pin,
                      error: _error,
                      loading: _loading,
                      onDigit: _onDigit,
                      onDelete: _onDelete,
                      onConfirm: _onConfirm,
                      onBack: () => setState(() {
                        _selected = null;
                        _pin = '';
                        _error = null;
                      }),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Employee selector ─────────────────────────────────────────────────────────

class _EmployeeSelector extends StatelessWidget {
  const _EmployeeSelector({required this.employees, required this.onSelect});

  final List<SessionEmployee> employees;
  final ValueChanged<SessionEmployee> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/brand/logo.png', width: 48, height: 48),
        SizedBox(height: context.tokens.spaceSm),
        AppText.headingMd('agora', color: AppColors.dark.foreground),
        SizedBox(height: context.tokens.spaceXs),
        AppText.body(
          'Select your profile to continue',
          color: AppColors.dark.mutedForeground,
        ),
        SizedBox(height: context.tokens.spaceXl),
        if (employees.isEmpty)
          AppText.body(
            'No employees found.\nPlease set up staff in Settings first.',
            color: AppColors.dark.mutedForeground,
            textAlign: TextAlign.center,
          )
        else
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: employees.map((e) => _AvatarTile(e, onSelect)).toList(),
          ),
      ],
    );
  }
}

class _AvatarTile extends StatelessWidget {
  const _AvatarTile(this.employee, this.onSelect);

  final SessionEmployee employee;
  final ValueChanged<SessionEmployee> onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(employee),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.dark.secondary,
            child: AppText.headingLg(
              employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
              color: AppColors.dark.secondaryForeground,
            ),
          ),
          SizedBox(height: context.tokens.spaceXs),
          AppText.bodySm(employee.name, color: AppColors.dark.foreground),
        ],
      ),
    );
  }
}

// ── PIN pad ───────────────────────────────────────────────────────────────────

class _PinPad extends StatelessWidget {
  const _PinPad({
    required this.employee,
    required this.pin,
    required this.error,
    required this.loading,
    required this.onDigit,
    required this.onDelete,
    required this.onConfirm,
    required this.onBack,
  });

  final SessionEmployee employee;
  final String pin;
  final String? error;
  final bool loading;
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            icon: Icon(
              AgoraIcons.chevron_left,
              color: AppColors.dark.foreground,
            ),
          ),
        ),
        SizedBox(height: context.tokens.spaceXs),
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.dark.secondary,
          child: AppText.headingLg(
            employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
            color: AppColors.dark.secondaryForeground,
          ),
        ),
        SizedBox(height: context.tokens.spaceSm),
        AppText.headingSm(employee.name, color: AppColors.dark.foreground),
        SizedBox(height: context.tokens.spaceXxs),
        AppText.body('Enter your PIN', color: AppColors.dark.mutedForeground),
        SizedBox(height: context.tokens.spaceLg),
        // PIN dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (i) => Container(
              margin: EdgeInsets.symmetric(horizontal: context.tokens.spaceXxs),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < pin.length
                    ? AppColors.dark.primary
                    : AppColors.dark.muted,
              ),
            ),
          ),
        ),
        if (error != null) ...[
          SizedBox(height: context.tokens.spaceSm),
          AppText.bodySm(error!, color: AppColors.dark.destructive),
        ],
        SizedBox(height: context.tokens.spaceLg),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            ...[
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
            ].map((d) => _DigitButton(digit: d, onTap: () => onDigit(d))),
            const SizedBox.shrink(),
            _DigitButton(digit: '0', onTap: () => onDigit('0')),
            _DeleteButton(onTap: onDelete),
          ],
        ),
        SizedBox(height: context.tokens.spaceLg),
        AppButton.primary(
          onPressed: pin.length >= 4 ? onConfirm : null,
          label: 'Unlock',
          isLoading: loading,
        ),
        if (kDebugMode) ...[
          SizedBox(height: context.tokens.spaceSm),
          AppButton.destructive(
            label: 'Skip PIN (debug)',
            size: AppButtonSize.sm,
            onPressed: () =>
                context.read<SessionCubit>().debugSkipPin(employee.id),
          ),
        ],
      ],
    );
  }
}

class _DigitButton extends StatelessWidget {
  const _DigitButton({required this.digit, required this.onTap});
  final String digit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dark.card,
      borderRadius: context.tokens.borderRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: context.tokens.borderRadiusLg,
        child: Center(
          child: AppText.headingMd(digit, color: AppColors.dark.foreground),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dark.card,
      borderRadius: context.tokens.borderRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: context.tokens.borderRadiusLg,
        child: Center(
          child: Icon(
            AgoraIcons.eraser,
            color: AppColors.dark.foreground,
            size: 22,
          ),
        ),
      ),
    );
  }
}
