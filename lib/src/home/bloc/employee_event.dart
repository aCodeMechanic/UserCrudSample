
part of 'employee_bloc.dart';


sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadEmployees extends EmployeeEvent {}

final class AddEmployee extends EmployeeEvent {
  const AddEmployee({required this.employee});

  final EmployeeCompanion employee;

  @override
  List<Object?> get props => [employee];
}

final class UpdateEmployee extends EmployeeEvent {
  const UpdateEmployee({required this.employee});

  final EmployeeData employee; //Changed Employee to EmployeeData

  @override
  List<Object?> get props => [employee];
}

final class DeleteEmployee extends EmployeeEvent {
  const DeleteEmployee({required this.employee});

  final EmployeeData employee; //Changed Employee to EmployeeData

  @override
  List<Object?> get props => [employee];
}
final class UndoDeleteEmployee extends EmployeeEvent {
  const UndoDeleteEmployee({required this.employee});

  final EmployeeData employee; //Changed Employee to EmployeeData

  @override
  List<Object?> get props => [employee];
}
