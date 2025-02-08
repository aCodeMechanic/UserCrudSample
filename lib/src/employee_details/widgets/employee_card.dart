import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:user_crud_sample/database/database.dart';
import 'package:user_crud_sample/src/home/bloc/employee_bloc.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({Key? key, required this.employee}) : super(key: key);

  final EmployeeData employee;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2, // Subtle shadow
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500, // Semi-bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.role,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600], // Slightly darker grey
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start Date: ${DateFormat('dd MMM yyyy').format(employee.startDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            // Soft Delete Button (Red Square)
            InkWell(
              onTap: () {
                // Dispatch the DeleteEmployee event (soft delete)
                context.read<EmployeeBloc>().add(DeleteEmployee(employee: employee));
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5), // Optional: round the corners
                ),
                child: const Icon(
                  Icons.delete, // Optional: add a trash can icon
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
