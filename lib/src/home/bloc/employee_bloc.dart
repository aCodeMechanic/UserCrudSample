import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../database/employee_dao.dart';
import '../../../database/database.dart';

part 'employee_event.dart';
part 'employee_state.dart';



class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeDao employeeDao;

  EmployeeBloc({required this.employeeDao}) : super(EmployeeInitial()) {
    on<LoadEmployees>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final employees = await employeeDao.getActiveEmployees(); //Load Active Employees
        emit(EmployeeLoaded(employees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<AddEmployee>((event, emit) async {
      try {
        await employeeDao.insertEmployee(event.employee);
        add(LoadEmployees()); // Reload the list
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      try {
        await employeeDao.updateEmployee(event.employee);
        add(LoadEmployees()); // Reload the list
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        //Soft delete instead of hard delete
        final employeeToDelete = event.employee.copyWith(isDeleted: true);
        await employeeDao.updateEmployee(employeeToDelete);
        add(LoadEmployees()); // Reload the list
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<UndoDeleteEmployee>((event, emit) async {
      try {
        //Soft delete instead of hard delete
        final employeeToDelete = event.employee.copyWith(isDeleted: false);
        await employeeDao.updateEmployee(employeeToDelete);
        add(LoadEmployees()); // Reload the list
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });
  }
}

