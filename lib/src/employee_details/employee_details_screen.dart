import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_crud_sample/database/database.dart';
import 'package:user_crud_sample/src/home/bloc/employee_bloc.dart';

import '../widgets/custom_date_picker.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final EmployeeData? employee; // Nullable employee for add/edit

  const EmployeeDetailsScreen({Key? key, this.employee}) : super(key: key);

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedRole;
  DateTime? _startDate;
  DateTime? _endDate;

  // List of roles for the dropdown
  final List<String> _roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _selectedRole = widget.employee?.role ?? _roles.first;
    _startDate = widget.employee?.startDate;
    _endDate = widget.employee?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomDatePicker();
      },
    );
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Header background color
            hintColor: Colors.blue, // Accent color
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null
            ? 'Add Employee Details'
            : 'Edit Employee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    hintText: 'Employee Name', prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the employee name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                    hintText: 'Select Role', prefixIcon: Icon(Icons.work)),
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Start Date'),
                        TextButton(
                          onPressed: () => _selectStartDate(context),
                          child: Text(
                            _startDate == null
                                ? 'No date chosen!'
                                : DateFormat('dd MMM yyyy').format(_startDate!),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('End Date'),
                        TextButton(
                          onPressed: () => _selectEndDate(context),
                          child: Text(
                            _endDate == null
                                ? 'No date chosen!'
                                : DateFormat('dd MMM yyyy').format(_endDate!),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel and go back
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, save the data
                        final String name = _nameController.text;

                        if (widget.employee == null) {
                          // Adding a new employee
                          final employee = EmployeeCompanion(
                            name: drift.Value(name),
                            role: drift.Value(_selectedRole),
                            startDate: drift.Value(_startDate!),
                            endDate: drift.Value(_endDate),
                          );
                          context
                              .read<EmployeeBloc>()
                              .add(AddEmployee(employee: employee));
                        } else {
                          // Editing an existing employee
                          final updatedEmployee = widget.employee!.copyWith(
                            name: name,
                            role: _selectedRole,
                            startDate: _startDate!,
                            endDate: drift.Value(_endDate),
                          );
                          context
                              .read<EmployeeBloc>()
                              .add(UpdateEmployee(employee: updatedEmployee));
                        }
                        Navigator.pop(context,
                            true); // Save and go back, passing true to reload
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
