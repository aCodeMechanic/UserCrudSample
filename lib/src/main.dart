import 'package:flutter/material.dart';
import 'package:user_crud_sample/src/screens/home/home.dart';
import 'package:user_crud_sample/src/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employees Demo',
      theme: appTheme,
      home: const Home(title: 'Employee List'),
    );
  }
}