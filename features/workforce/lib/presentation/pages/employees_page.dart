import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/employee.dart';
import 'package:feature_workforce/domain/models/employee_role.dart';
import 'package:feature_workforce/presentation/blocs/employees/employees_bloc.dart';
import 'package:feature_workforce/presentation/widgets/employee_form.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeesBloc>().add(const EmployeesEvent.started());
  }

  Future<void> _onAdd() async {
    final data = await EmployeeForm.showCreate(context);
    if (data == null || !mounted) return;
    context.read<EmployeesBloc>().add(
      EmployeesEvent.created(
        Employee(
          id: 0,
          name: data.name,
          pin: data.pin,
          role: data.role,
          isActive: data.isActive,
          hourlyRateCents: data.hourlyRateCents,
        ),
      ),
    );
  }

  Future<void> _onEdit(Employee employee) async {
    final data = await EmployeeForm.showEdit(context, employee);
    if (data == null || !mounted) return;
    final updated = employee.copyWith(
      name: data.name,
      pin: data.pin.isEmpty ? employee.pin : data.pin,
      role: data.role,
      isActive: data.isActive,
      hourlyRateCents: data.hourlyRateCents,
    );
    context.read<EmployeesBloc>().add(EmployeesEvent.updated(updated));
  }

  Future<void> _onDelete(Employee employee) async {
    final confirmed = await ConfirmationDialog.showDelete(
      context: context,
      title: 'Delete Employee?',
      message:
          'Are you sure you want to remove ${employee.name}? This cannot be undone.',
    );
    if (confirmed && mounted) {
      context.read<EmployeesBloc>().add(EmployeesEvent.deleted(employee.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar.of(
        context,
        title: 'Staff',
        actions: [
          AppIconButton.primary(
            onPressed: _onAdd,
            icon: const Icon(AgoraIcons.plus),
          ),
        ],
      ),
      body: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) => state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (employees) => _EmployeesList(
            employees: employees,
            onAdd: _onAdd,
            onEdit: _onEdit,
            onDelete: _onDelete,
          ),
          error: (message) => Center(
            child: AppText.body(message, color: context.colors.destructive),
          ),
        ),
      ),
    );
  }
}

class _EmployeesList extends StatefulWidget {
  const _EmployeesList({
    required this.employees,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Employee> employees;
  final VoidCallback onAdd;
  final ValueChanged<Employee> onEdit;
  final ValueChanged<Employee> onDelete;

  @override
  State<_EmployeesList> createState() => _EmployeesListState();
}

class _EmployeesListState extends State<_EmployeesList> {
  String _search = '';

  List<Employee> get _filtered => widget.employees
      .where((e) => e.name.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Row(
            children: [
              const AppText.headingSm('Employees'),
              const Spacer(),
              SizedBox(
                width: 240,
                child: AppTextField(
                  onChanged: (v) => setState(() => _search = v),
                  hintText: 'Search employees…',
                  prefix: const Icon(AgoraIcons.search, size: 20),
                ),
              ),
              SizedBox(width: context.tokens.spaceSm),
              AppButton.primary(
                onPressed: widget.onAdd,
                label: 'Add Employee',
                leadingIcon: const Icon(AgoraIcons.plus),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _filtered.isEmpty
              ? _EmptyState(onAdd: widget.onAdd)
              : ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final emp = _filtered[index];
                    return _EmployeeTile(
                      employee: emp,
                      onEdit: () => widget.onEdit(emp),
                      onDelete: () => widget.onDelete(emp),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colors.primary.withValues(alpha: 0.12),
        child: AppText.titleMd(
          employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
          color: colors.primary,
        ),
      ),
      title: AppText.body(employee.name),
      subtitle: AppText.bodySm(
        '${employee.role.label} · ${employee.formattedHourlyRate}',
        color: colors.mutedForeground,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoleBadge(role: employee.role),
          SizedBox(width: context.tokens.spaceXs),
          _StatusBadge(isActive: employee.isActive),
          SizedBox(width: context.tokens.spaceXs),
          AppIconButton.ghost(
            icon: const Icon(AgoraIcons.pencil, size: 20),
            onPressed: onEdit,
          ),
          AppIconButton.ghost(
            icon: Icon(AgoraIcons.trash, size: 20, color: colors.destructive),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final EmployeeRole role;

  Color _color(BuildContext context) => switch (role) {
    EmployeeRole.owner => context.colors.primary,
    EmployeeRole.manager => context.colors.warning,
    EmployeeRole.cashier => context.colors.mutedForeground,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spaceXs,
        vertical: context.tokens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: context.tokens.borderRadiusLg,
      ),
      child: AppText.label(role.label, color: color),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spaceXs,
        vertical: context.tokens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: isActive ? colors.success.withValues(alpha: 0.12) : colors.muted,
        borderRadius: context.tokens.borderRadiusLg,
      ),
      child: AppText.label(
        isActive ? 'Active' : 'Inactive',
        color: isActive ? colors.success : colors.mutedForeground,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AgoraIcons.user_group, size: 64, color: context.colors.border),
          SizedBox(height: context.tokens.spaceMd),
          AppText.titleMd(
            'No employees yet',
            color: context.colors.mutedForeground,
          ),
          SizedBox(height: context.tokens.spaceXs),
          AppButton.primary(
            onPressed: onAdd,
            label: 'Add First Employee',
            leadingIcon: const Icon(AgoraIcons.plus),
          ),
        ],
      ),
    );
  }
}
