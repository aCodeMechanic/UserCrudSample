part of 'employee_bloc.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

final class EmployeeInitial extends EmployeeState {}

final class EmployeeLoading extends EmployeeState {}

final class EmployeeLoaded extends EmployeeState {
  const EmployeeLoaded(this.employees);

  final List<EmployeeData> employees; //Changed Employee to EmployeeData

  @override
  List<Object?> get props => [employees];
}

final class EmployeeError extends EmployeeState {
  const EmployeeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
