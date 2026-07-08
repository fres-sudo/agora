import 'package:feature_workforce/domain/models/employee.dart';
import 'package:feature_workforce/domain/models/employee_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

class EmployeeFormData {
  EmployeeFormData({
    this.name = '',
    this.pin = '',
    this.role = EmployeeRole.cashier,
    this.isActive = true,
    this.hourlyRateCents = 0,
  });

  String name;
  String pin;
  EmployeeRole role;
  bool isActive;
  int hourlyRateCents;
}

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key, this.employee});

  final Employee? employee;

  static Future<EmployeeFormData?> showCreate(BuildContext context) =>
      showAdaptiveDialog<EmployeeFormData>(
        context: context,
        builder: (_) => const EmployeeForm(),
      );

  static Future<EmployeeFormData?> showEdit(
    BuildContext context,
    Employee employee,
  ) => showAdaptiveDialog<EmployeeFormData>(
    context: context,
    builder: (_) => EmployeeForm(employee: employee),
  );

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.employee?.name);
  late final _pinCtrl = TextEditingController(text: widget.employee?.pin);
  late final _rateCtrl = TextEditingController(
    text: widget.employee != null
        ? (widget.employee!.hourlyRateCents / 100).toStringAsFixed(2)
        : '',
  );
  late EmployeeRole _role = widget.employee?.role ?? EmployeeRole.cashier;
  late bool _isActive = widget.employee?.isActive ?? true;
  bool _obscurePin = true;

  bool get _isEditing => widget.employee != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final rateCents = ((double.tryParse(_rateCtrl.text) ?? 0) * 100).round();
    Navigator.of(context).pop(
      EmployeeFormData(
        name: _nameCtrl.text.trim(),
        pin: _pinCtrl.text.trim(),
        role: _role,
        isActive: _isActive,
        hourlyRateCents: rateCents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppText.titleLg(_isEditing ? 'Edit Employee' : 'Add Employee'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _pinCtrl,
                label: _isEditing
                    ? 'PIN (leave blank to keep current)'
                    : 'PIN (4–6 digits)',
                suffix: IconButton(
                  icon: Icon(_obscurePin ? AgoraIcons.eye : AgoraIcons.eye),
                  onPressed: () => setState(() => _obscurePin = !_obscurePin),
                ),
                obscureText: _obscurePin,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (v) {
                  if (_isEditing && (v == null || v.isEmpty)) return null;
                  if (v == null || v.length < 4) {
                    return 'PIN must be 4–6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EmployeeRole>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: EmployeeRole.values
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: AppText.body(r.label),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _role = v!),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _rateCtrl,
                label: 'Hourly Rate',
                prefixText: '\$',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const AppText.body('Active'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton.ghost(
          onPressed: () => Navigator.of(context).pop(),
          label: 'Cancel',
        ),
        AppButton.primary(
          onPressed: _submit,
          label: _isEditing ? 'Save' : 'Add Employee',
        ),
      ],
    );
  }
}
