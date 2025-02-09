import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import 'package:intl/intl.dart';
import 'package:user_crud_sample/database/database.dart';
import 'package:user_crud_sample/src/home/bloc/employee_bloc.dart';
import 'package:user_crud_sample/src/widgets/custom_hero.dart';
import 'package:user_crud_sample/theme/theme.dart';

import '../employee_details_screen.dart';
class EmployeeCard extends StatelessWidget {
  const EmployeeCard({Key? key, required this.employee}) : super(key: key);

  final EmployeeData employee;

  @override
  Widget build(BuildContext context) {
    return CustomHero(
      tag: "${employee.id}",
      child: GestureDetector(
        onTap: (){
          var value = Navigator.push(
            context,
            MaterialPageRoute(maintainState: true,
              builder: (context) =>
                  EmployeeDetailsScreen(
                      employee: employee), // Pass null for new employee
            ),
          );
        },
        child: Container(
          color: Colors.white,
          child: SwipeActionCell(
            closeWhenScrolling: true,
            backgroundColor: Colors.transparent,
            openAnimationCurve: Curves.ease,
            closeAnimationCurve: Curves.ease,
            key: Key('${employee.id}'),
            trailingActions: [
              SwipeAction(
                closeOnTap: true,
                color: Colors.transparent,
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    /// set you real bg color in your content
                    color: Colors.red[700],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
                    child: Text('Delete',style: textTheme(color: Colors.white),),
                  ),
                ),
                onTap: (handler) async {
                  context.read<EmployeeBloc>().add(DeleteEmployee(employee: employee));
                  final snackBar = SnackBar(
                    content: const Text('Yay! A SnackBar!'),
                    action: SnackBarAction(
                      label: 'Undo',textColor: primaryColor,
                      onPressed: () async {
                        context.read<EmployeeBloc>().add(UndoDeleteEmployee(employee: employee));
                        await handler(false);
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: textTheme(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Semi-bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.role,
                    style: textTheme(
                      fontSize: 14,
                      color: Colors.grey[600], // Slightly darker grey
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start Date: ${DateFormat('dd MMM yyyy').format(employee.startDate)}',
                    style: textTheme(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
