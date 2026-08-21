import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:payment_contracts/payment_contracts.dart';
import 'package:ui_kit/ui_kit.dart';

/// Configure which payment methods are available at checkout.
///
/// Toggling a method persists a boolean flag via [SettingsCubit] under keys
/// defined in [AppSettingsDao] (e.g. [AppSettingsDao.keyPaymentMethodCashEnabled]).
/// The checkout sheet reads those flags to filter the visible payment options.
class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({super.key});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  CardPaymentStatus? _sumUpStatus;
  bool _loadingSumUp = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sumUpStatus == null && !_loadingSumUp) _refreshSumUp();
  }

  Future<void> _refreshSumUp() async {
    setState(() => _loadingSumUp = true);
    final status = await context.read<CardPaymentService>().getStatus();
    if (!mounted) return;
    setState(() {
      _sumUpStatus = status;
      _loadingSumUp = false;
    });
  }

  Future<void> _runSumUp(
    Future<CardPaymentStatus> Function(CardPaymentService service) action,
  ) async {
    setState(() => _loadingSumUp = true);
    final status = await action(context.read<CardPaymentService>());
    if (!mounted) return;
    setState(() {
      _sumUpStatus = status;
      _loadingSumUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        // Cash is safe by default; card stays off until SumUp is configured.
        final cashEnabled = cubit.getBool(
          AppSettingsDao.keyPaymentMethodCashEnabled,
          defaultValue: true,
        );
        final cardEnabled = cubit.getBool(
          AppSettingsDao.keyPaymentMethodCardEnabled,
          defaultValue: false,
        );

        return SettingsSectionScaffold(
          title: 'Payment Method',
          actionButton: const SizedBox.shrink(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.body(
                'Enable the payment methods operators can use at checkout.',
                color: context.colors.mutedForeground,
              ),
              SizedBox(height: context.tokens.spacing.lg),
              _MethodTile(
                icon: AgoraIcons.money,
                label: 'Cash',
                description: 'Accept cash payments with change calculation.',
                isEnabled: cashEnabled,
                onChanged: (value) => cubit.updateBool(
                  AppSettingsDao.keyPaymentMethodCashEnabled,
                  value,
                ),
              ),
              const Divider(height: 24),
              _MethodTile(
                icon: AgoraIcons.card,
                label: 'Card',
                description: _sumUpDescription,
                isEnabled: cardEnabled,
                onChanged: _sumUpStatus?.canCharge == true
                    ? (value) => cubit.updateBool(
                        AppSettingsDao.keyPaymentMethodCardEnabled,
                        value,
                      )
                    : null,
              ),
              SizedBox(height: context.tokens.spacing.sm),
              _SumUpActions(
                status: _sumUpStatus,
                isLoading: _loadingSumUp,
                onLogin: () => _runSumUp((service) => service.login()),
                onReaderSettings: () =>
                    _runSumUp((service) => service.openReaderSettings()),
                onLogout: () => _runSumUp((service) => service.logout()),
                onRefresh: _refreshSumUp,
              ),
              SizedBox(height: context.tokens.spacing.md),
              if (!cashEnabled && !cardEnabled)
                Container(
                  padding: EdgeInsets.all(context.tokens.spacing.sm),
                  decoration: BoxDecoration(
                    color: context.colors.warning.withValues(alpha: 0.12),
                    borderRadius: context.tokens.radius.borderLg,
                    border: Border.all(
                      color: context.colors.warning.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        AgoraIcons.alert_triangle,
                        color: context.colors.warning,
                        size: 18,
                      ),
                      SizedBox(width: context.tokens.spacing.xs),
                      Expanded(
                        child: AppText.bodySm(
                          'At least one payment method must be enabled.',
                          color: context.colors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String get _sumUpDescription {
    final status = _sumUpStatus;
    if (_loadingSumUp && status == null) return 'Checking SumUp…';
    return switch (status?.readiness) {
      CardPaymentReadiness.ready =>
        status!.readerConnected
            ? 'SumUp is ready; the saved reader is connected.'
            : 'SumUp is logged in; the reader will connect during checkout.',
      CardPaymentReadiness.loggedOut =>
        'Log in to SumUp to enable card payments.',
      CardPaymentReadiness.notConfigured =>
        'Add SUMUP_AFFILIATE_KEY to the build configuration.',
      _ => status?.message ?? 'SumUp is unavailable on this device.',
    };
  }
}

class _SumUpActions extends StatelessWidget {
  const _SumUpActions({
    required this.status,
    required this.isLoading,
    required this.onLogin,
    required this.onReaderSettings,
    required this.onLogout,
    required this.onRefresh,
  });

  final CardPaymentStatus? status;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onReaderSettings;
  final VoidCallback onLogout;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final readiness = status?.readiness;
    return Wrap(
      spacing: context.tokens.spacing.xs,
      runSpacing: context.tokens.spacing.xs,
      children: [
        if (readiness == CardPaymentReadiness.loggedOut)
          AppButton.outline(
            label: 'Log in to SumUp',
            isLoading: isLoading,
            onPressed: isLoading ? null : onLogin,
          ),
        if (readiness == CardPaymentReadiness.ready) ...[
          AppButton.outline(
            label: 'Reader settings',
            isLoading: isLoading,
            onPressed: isLoading ? null : onReaderSettings,
          ),
          AppButton.outline(
            label: 'Log out',
            onPressed: isLoading ? null : onLogout,
          ),
        ],
        AppButton.outline(
          label: 'Refresh',
          onPressed: isLoading ? null : onRefresh,
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.isEnabled,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(context.tokens.spacing.xs),
          decoration: BoxDecoration(
            color: isEnabled
                ? colors.primary.withValues(alpha: 0.1)
                : colors.muted,
            borderRadius: context.tokens.radius.borderLg,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isEnabled ? colors.primary : colors.mutedForeground,
          ),
        ),
        SizedBox(width: context.tokens.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMd(label),
              SizedBox(height: context.tokens.spacing.xxs),
              AppText.bodySm(description, color: colors.mutedForeground),
            ],
          ),
        ),
        Switch(value: isEnabled, onChanged: onChanged),
      ],
    );
  }
}
