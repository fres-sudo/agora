import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feature_onboarding/domain/models/onboarding_draft.dart';
import 'package:feature_onboarding/presentation/blocs/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

/// Shared heading (large title + helper text) used at the top of every step.
class _StepHeader extends StatelessWidget {
  const _StepHeader(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.headingLg(title),
        const SizedBox(height: 8),
        AppText.body(subtitle, color: context.colors.mutedForeground),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// A large, tappable option row with icon, title, description and a selected
/// state. Used for business-type and menu choices.
class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: selected ? colors.accent : colors.card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? colors.primary : colors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: selected ? colors.primary : colors.mutedForeground),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.titleMd(title),
                      const SizedBox(height: 2),
                      AppText.bodySm(description, color: colors.mutedForeground),
                    ],
                  ),
                ),
                if (selected) Icon(Icons.check_circle, color: colors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Welcome
// ---------------------------------------------------------------------------
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          'Welcome to Agora',
          "Let's set up your point of sale. It only takes a minute — we'll ask "
              'a few simple questions and then you can start selling.',
        ),
        _bullet(context, Icons.storefront, 'Tell us about your business'),
        _bullet(context, Icons.percent, 'Set your tax and currency'),
        _bullet(context, Icons.payments, 'Choose how you take payment'),
        _bullet(context, Icons.restaurant_menu, 'Add your menu — or start from a sample'),
      ],
    );
  }

  Widget _bullet(BuildContext context, IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Icon(icon, size: 20, color: context.colors.primary),
        const SizedBox(width: 12),
        Expanded(child: AppText.body(text)),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// 2. Business type
// ---------------------------------------------------------------------------
class BusinessTypeStep extends StatelessWidget {
  const BusinessTypeStep({required this.draft, super.key});
  final OnboardingDraft draft;

  static const _descriptions = {
    BusinessType.restaurant: 'Table service, staff logins, dine-in and takeaway.',
    BusinessType.barCafe: 'Fast counter service for drinks and light food.',
    BusinessType.quickService: 'Counter and takeaway, quick checkout, single operator.',
    BusinessType.festival: 'Offline, cash-first stall for events — no login needed.',
  };

  static const _icons = {
    BusinessType.restaurant: Icons.restaurant,
    BusinessType.barCafe: Icons.local_cafe,
    BusinessType.quickService: Icons.fastfood,
    BusinessType.festival: Icons.celebration,
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          'What kind of business is this?',
          'This tailors the app to how you work — which screens you see and the '
              'defaults we use. You can change it later.',
        ),
        for (final type in BusinessType.values)
          _SelectableTile(
            icon: _icons[type]!,
            title: type.label,
            description: _descriptions[type]!,
            selected: draft.type == type,
            onTap: () => cubit.selectType(type),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Business details
// ---------------------------------------------------------------------------
class BusinessDetailsStep extends StatefulWidget {
  const BusinessDetailsStep({required this.draft, super.key});
  final OnboardingDraft draft;

  @override
  State<BusinessDetailsStep> createState() => _BusinessDetailsStepState();
}

class _BusinessDetailsStepState extends State<BusinessDetailsStep> {
  late final _name = TextEditingController(text: widget.draft.businessName);
  late final _address = TextEditingController(text: widget.draft.address);
  late final _phone = TextEditingController(text: widget.draft.phone);
  late final _email = TextEditingController(text: widget.draft.email);
  late final _city = TextEditingController(text: widget.draft.city);
  late final _country = TextEditingController(text: widget.draft.country);

  @override
  void dispose() {
    for (final c in [_name, _address, _phone, _email, _city, _country]) {
      c.dispose();
    }
    super.dispose();
  }

  void _sync() {
    context.read<OnboardingCubit>().updateDraft(
      widget.draft.copyWith(
        businessName: _name.text,
        address: _address.text,
        phone: _phone.text,
        email: _email.text,
        city: _city.text,
        country: _country.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          'Your business details',
          'This appears on receipts your customers get. Only the name is required.',
        ),
        AppTextField(
          controller: _name,
          label: 'Business name',
          hintText: 'e.g. Trattoria da Marco',
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => _sync(),
        ),
        const SizedBox(height: 12),
        AppTextField(controller: _address, label: 'Address', onChanged: (_) => _sync()),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: AppTextField(controller: _city, label: 'City', onChanged: (_) => _sync())),
            const SizedBox(width: 12),
            Expanded(child: AppTextField(controller: _country, label: 'Country', onChanged: (_) => _sync())),
          ],
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _phone,
          label: 'Phone',
          keyboardType: TextInputType.phone,
          onChanged: (_) => _sync(),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _email,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => _sync(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Tax & currency
// ---------------------------------------------------------------------------
class TaxCurrencyStep extends StatefulWidget {
  const TaxCurrencyStep({required this.draft, super.key});
  final OnboardingDraft draft;

  @override
  State<TaxCurrencyStep> createState() => _TaxCurrencyStepState();
}

class _TaxCurrencyStepState extends State<TaxCurrencyStep> {
  late final _currency = TextEditingController(text: widget.draft.currencySymbol);
  late final _tax = TextEditingController(
    text: widget.draft.taxRate == 0 ? '' : widget.draft.taxRate.toString(),
  );

  @override
  void dispose() {
    _currency.dispose();
    _tax.dispose();
    super.dispose();
  }

  void _sync() {
    context.read<OnboardingCubit>().updateDraft(
      widget.draft.copyWith(
        currencySymbol: _currency.text.isEmpty ? '€' : _currency.text,
        taxRate: double.tryParse(_tax.text.replaceAll(',', '.')) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          'Tax & currency',
          "We've pre-filled sensible values for your business type. Adjust them "
              'to match your local rules.',
        ),
        AppTextField(
          controller: _currency,
          label: 'Currency symbol',
          hintText: '€',
          onChanged: (_) => _sync(),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _tax,
          label: 'Tax rate',
          hintText: '0',
          suffixText: '%',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
          onChanged: (_) => _sync(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Payments
// ---------------------------------------------------------------------------
class PaymentsStep extends StatelessWidget {
  const PaymentsStep({required this.draft, super.key});
  final OnboardingDraft draft;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          'How do you take payment?',
          'Turn on the methods you accept. You can wire up a card reader later '
              'in Settings.',
        ),
        _toggle(
          context,
          icon: Icons.euro,
          title: 'Cash',
          value: draft.cashEnabled,
          onChanged: (v) => cubit.updateDraft(draft.copyWith(cashEnabled: v)),
        ),
        _toggle(
          context,
          icon: Icons.credit_card,
          title: 'Card',
          value: draft.cardEnabled,
          onChanged: (v) => cubit.updateDraft(draft.copyWith(cardEnabled: v)),
        ),
      ],
    );
  }

  Widget _toggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: context.colors.mutedForeground),
          const SizedBox(width: 12),
          Expanded(child: AppText.titleMd(title)),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Team (staff-login businesses only)
// ---------------------------------------------------------------------------
class TeamStep extends StatefulWidget {
  const TeamStep({required this.draft, super.key});
  final OnboardingDraft draft;

  @override
  State<TeamStep> createState() => _TeamStepState();
}

class _TeamStepState extends State<TeamStep> {
  final _name = TextEditingController();
  final _pin = TextEditingController();
  String _role = 'owner';

  @override
  void dispose() {
    _name.dispose();
    _pin.dispose();
    super.dispose();
  }

  bool get _canAdd =>
      _name.text.trim().isNotEmpty && _pin.text.trim().length >= 4;

  void _add() {
    if (!_canAdd) return;
    context.read<OnboardingCubit>().addStaff(
      StaffDraft(name: _name.text.trim(), role: _role, pin: _pin.text.trim()),
    );
    _name.clear();
    _pin.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          'Add your team',
          'Each person signs in with a PIN. Add at least one — you can add the '
              'rest later.',
        ),
        for (var i = 0; i < widget.draft.staff.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.person_outline, size: 20),
                const SizedBox(width: 12),
                Expanded(child: AppText.body(widget.draft.staff[i].name)),
                AppText.bodySm(
                  widget.draft.staff[i].role,
                  color: context.colors.mutedForeground,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => cubit.removeStaffAt(i),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _name,
          label: 'Name',
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _pin,
                label: 'PIN (4–6 digits)',
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'owner', child: AppText.body('Owner')),
                  DropdownMenuItem(value: 'manager', child: AppText.body('Manager')),
                  DropdownMenuItem(value: 'cashier', child: AppText.body('Cashier')),
                ],
                onChanged: (v) => setState(() => _role = v ?? 'owner'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppButton.secondary(
          label: 'Add team member',
          leadingIcon: const Icon(Icons.add),
          onPressed: _canAdd ? _add : null,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Menu
// ---------------------------------------------------------------------------
class MenuStep extends StatelessWidget {
  const MenuStep({required this.draft, super.key});
  final OnboardingDraft draft;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          'Set up your menu',
          'Start from a ready-made sample you can edit, or begin with a blank '
              'catalog and add your own products.',
        ),
        _SelectableTile(
          icon: Icons.auto_awesome,
          title: 'Start with a sample menu',
          description: 'A starter catalog for a ${draft.profile.type.label.toLowerCase()} you can tweak.',
          selected: draft.menuChoice == MenuChoice.sample,
          onTap: () => cubit.setMenuChoice(MenuChoice.sample),
        ),
        _SelectableTile(
          icon: Icons.note_add_outlined,
          title: 'Start empty',
          description: 'No products yet — add your own from the Products screen.',
          selected: draft.menuChoice == MenuChoice.empty,
          onTap: () => cubit.setMenuChoice(MenuChoice.empty),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Review
// ---------------------------------------------------------------------------
class ReviewStep extends StatelessWidget {
  const ReviewStep({required this.draft, super.key});
  final OnboardingDraft draft;

  @override
  Widget build(BuildContext context) {
    final payments = [
      if (draft.cashEnabled) 'Cash',
      if (draft.cardEnabled) 'Card',
    ].join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          "You're all set",
          'Review your setup and finish. You can change any of this later in '
              'Settings.',
        ),
        _row(context, 'Business type', draft.type?.label ?? '—'),
        _row(context, 'Name', draft.businessName.isEmpty ? '—' : draft.businessName),
        _row(context, 'Currency', draft.currencySymbol),
        _row(context, 'Tax', '${draft.taxRate.toStringAsFixed(draft.taxRate % 1 == 0 ? 0 : 2)}%'),
        _row(context, 'Payments', payments.isEmpty ? '—' : payments),
        if (draft.profile.requiresStaffLogin)
          _row(context, 'Team', '${draft.staff.length} member(s)')
        else
          _row(context, 'Login', 'Single user (no login)'),
        _row(
          context,
          'Menu',
          draft.menuChoice == MenuChoice.sample ? 'Sample catalog' : 'Empty',
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: AppText.bodySm(label, color: context.colors.mutedForeground),
        ),
        Expanded(child: AppText.body(value)),
      ],
    ),
  );
}
