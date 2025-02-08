import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_crud_sample/src/home/bloc/employee_bloc.dart';
import 'package:user_crud_sample/src/home/home.dart';
import 'package:user_crud_sample/theme/theme.dart';
import 'database/database.dart';
import 'database/employee_dao.dart';
import 'src/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppDatabase _database = AppDatabase();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeBloc(employeeDao: EmployeeDao(_database))
        ..add(LoadEmployees()),
      child: MaterialApp(
        title: 'Employees Demo',
        theme: appTheme,
        home: HomeScreen(), // Use the Home Screen Here
      ),
    );
  }
}
