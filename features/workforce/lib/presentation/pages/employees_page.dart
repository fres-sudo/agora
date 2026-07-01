import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/employee.dart';
import 'package:feature_workforce/domain/models/employee_role.dart';
import 'package:feature_workforce/presentation/blocs/employees/employees_bloc.dart';
import 'package:feature_workforce/presentation/widgets/employee_form.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
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
      appBar: AppBar(
        leading: context.isTabletOrLarger
            ? null
            : AppIconButton.ghost(
                onPressed: AppShellScope.maybeOf(context)?.openSidebar,
                icon: const Icon(Icons.menu_rounded),
              ),
        title: const Text('Employees'),
        actions: context.isTabletOrLarger
            ? const [
                AppShellOperatorChip(),
                SizedBox(width: 8),
                AppShellUserMenu(),
                SizedBox(width: 12),
              ]
            : null,
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
          error: (message) =>
              Center(child: Text(message, style: const TextStyle(color: Colors.red))),
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
      .where(
        (e) => e.name.toLowerCase().contains(_search.toLowerCase()),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Row(
            children: [
              Text(
                'Employees',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 240,
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: const InputDecoration(
                    hintText: 'Search employees…',
                    prefixIcon: Icon(Icons.search, size: 20),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AppButton.primary(
                onPressed: widget.onAdd,
                label: 'Add Employee',
                leadingIcon: const Icon(Icons.add),
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
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary500.withValues(alpha: 0.12),
        child: Text(
          employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: AppColors.primary500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(employee.name, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        '${employee.role.label} · ${employee.formattedHourlyRate}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoleBadge(role: employee.role),
          const SizedBox(width: 8),
          _StatusBadge(isActive: employee.isActive),
          const SizedBox(width: 8),
          AppIconButton.ghost(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: onEdit,
          ),
          AppIconButton.ghost(
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
              color: Colors.red,
            ),
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

  Color get _color => switch (role) {
    EmployeeRole.owner => AppColors.primary500,
    EmployeeRole.manager => Colors.orange,
    EmployeeRole.cashier => AppColors.neutral500,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
      child: Text(
        role.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.green.withValues(alpha: 0.12)
              : AppColors.neutral200,
          borderRadius: BorderRadius.circular(12),
        ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.green.shade700 : AppColors.neutral500,
        ),
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
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.neutral300,
          ),
          const SizedBox(height: 16),
          Text(
            'No employees yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          const SizedBox(height: 8),
          AppButton.primary(
            onPressed: onAdd,
            label: 'Add First Employee',
            leadingIcon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
