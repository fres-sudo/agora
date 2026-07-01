import 'package:bloc_exports/bloc_exports.dart';
import 'package:result/result.dart';
import 'package:feature_workforce/domain/models/employee.dart';
import 'package:feature_workforce/domain/repositories/workforce_repository.dart';
import 'package:result/result.dart';

part 'employees_event.dart';
part 'employees_state.dart';
part 'employees_bloc.freezed.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  EmployeesBloc({required WorkforceRepository workforceRepository})
      : _repo = workforceRepository,
        super(const EmployeesState.initial()) {
    on<_Started>(_onStarted);
    on<_Created>(_onCreate);
    on<_Updated>(_onUpdate);
    on<_Deleted>(_onDelete);
  }

  final WorkforceRepository _repo;

  Future<void> _onStarted(
    _Started event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(const EmployeesState.loading());
    await emit.forEach(
      _repo.watchActiveEmployees(),
      onData: (employees) => EmployeesState.loaded(employees),
      onError: (e, _) => EmployeesState.error(e.toString()),
    );
  }

  Future<void> _onCreate(_Created event, Emitter<EmployeesState> emit) async {
    final result = await _repo.createEmployee(event.employee);
    if (result case Error<Employee>(:final error)) {
      emit(EmployeesState.error(error.toString()));
    }
  }

  Future<void> _onUpdate(_Updated event, Emitter<EmployeesState> emit) async {
    final result = await _repo.updateEmployee(event.employee);
    if (result case Error<Employee>(:final error)) {
      emit(EmployeesState.error(error.toString()));
    }
  }

  Future<void> _onDelete(_Deleted event, Emitter<EmployeesState> emit) async {
    final result = await _repo.deleteEmployee(event.id);
    if (result case Error<int>(:final error)) {
      emit(EmployeesState.error(error.toString()));
    }
  }
}
