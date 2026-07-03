import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Configure which payment methods are available at checkout.
///
/// Toggling a method persists a boolean flag via [SettingsCubit] under keys
/// defined in [AppSettingsDao] (e.g. [AppSettingsDao.keyPaymentMethodCashEnabled]).
/// The checkout sheet reads those flags to filter the visible payment options.
class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        // Default both methods to enabled when not yet persisted.
        final cashEnabled = cubit.getBool(
          AppSettingsDao.keyPaymentMethodCashEnabled,
          defaultValue: true,
        );
        final cardEnabled = cubit.getBool(
          AppSettingsDao.keyPaymentMethodCardEnabled,
          defaultValue: true,
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
              const SizedBox(height: 24),
              _MethodTile(
                icon: Icons.payments_outlined,
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
                icon: Icons.credit_card,
                label: 'Card',
                description: 'Accept credit/debit card payments.',
                isEnabled: cardEnabled,
                onChanged: (value) => cubit.updateBool(
                  AppSettingsDao.keyPaymentMethodCardEnabled,
                  value,
                ),
              ),
              const SizedBox(height: 16),
              if (!cashEnabled && !cardEnabled)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppPalette.warning100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppPalette.warning300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_outlined, color: AppPalette.warning600, size: 18),
                      const SizedBox(width: 8),
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
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isEnabled ? AppPalette.primary100 : AppPalette.neutral100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isEnabled ? AppPalette.primary500 : AppPalette.neutral400,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMd(label),
              const SizedBox(height: 2),
              AppText.bodySm(description, color: colors.mutedForeground),
            ],
          ),
        ),
        Switch(value: isEnabled, onChanged: onChanged),
      ],
    );
  }
}
