import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_crud_sample/database/database.dart';
import 'package:user_crud_sample/src/home/bloc/employee_bloc.dart';
import 'package:user_crud_sample/src/widgets/custom_hero.dart';
import 'package:user_crud_sample/theme/theme.dart';
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
  late TextEditingController _selectedRoleController;
  late TextEditingController _selectedStartDateController;
  late TextEditingController _selectedEndDateController;
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
    _selectedRoleController =
        TextEditingController(text: widget.employee?.role ?? '');
    _startDate = widget.employee?.startDate;
    _endDate = widget.employee?.endDate;
    _selectedStartDateController =
        TextEditingController(text: _startDate == null ? '' : DateFormat('dd MMM yyyy').format(_startDate!),);
    _selectedEndDateController =
        TextEditingController(text: _endDate == null ? '' : DateFormat('dd MMM yyyy').format(_endDate!),);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _selectedRoleController.dispose();
    _selectedStartDateController.dispose();
    _selectedEndDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(endDate: _endDate,selectedDate: _startDate,);
      },
    );
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
        _selectedStartDateController.text = _startDate == null ? '' : DateFormat('dd MMM yyyy').format(_startDate!);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(
          allowNoDate: true,startDate: _startDate,selectedDate: _endDate,
        );
      },
    );
    if (pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
        _selectedEndDateController.text = _endDate == null ? '' : DateFormat('dd MMM yyyy').format(_endDate!);

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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomHero(
                    tag: "${widget.employee?.id ?? -1}",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              hintText: 'Employee Name',
                              prefixIcon: Icon(Icons.person_outline,
                                  color: primaryColor, size: 22)),
                          maxLines: 1,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the employee name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _selectedRoleController,
                          decoration: const InputDecoration(
                              hintText: 'Select Role',
                              prefixIcon: Icon(Icons.work_outline,
                                  color: primaryColor, size: 22),
                            suffixIcon: Icon(Icons.arrow_drop_down, color: primaryColor, size: 26),
                          ),
                          readOnly: true,
                          onTap: () {
                            _showRoleBottomSheet(context);
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child:
                              TextFormField(
                                controller: _selectedStartDateController,
                                decoration: const InputDecoration(
                                  hintText: 'No Date',
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: primaryColor, size: 22),
                                ),
                                readOnly: true,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Please select a start date';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  _selectStartDate(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_forward,color: primaryColor,size: 18,),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _selectedEndDateController,
                                decoration: const InputDecoration(
                                  hintText: 'No Date',
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: primaryColor, size: 22),
                                ),
                                readOnly: true,
                                onTap: () {
                                  _selectEndDate(context);
                                },
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 2,color: greyBackgroundColor,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor.withAlpha(30),
                              foregroundColor: primaryColor,
                            ),
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Form is valid, save the data
                                final String name = _nameController.text;

                                if (widget.employee == null) {
                                  // Adding a new employee
                                  final employee = EmployeeCompanion(
                                    name: drift.Value(name),
                                    role: drift.Value(_selectedRoleController.text),
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
                                    role: _selectedRoleController.text,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                      title: Center(child: Text(_roles[index])),
                      onTap: () {
                        setState(() {
                          _selectedRoleController.text = _roles[index];
                        });
                        Navigator.pop(context);
                      },
                    ),
                separatorBuilder: (context, index) => const Divider(
                      height: 2,
                      color: greyBackgroundColor,
                    ),
                itemCount: _roles.length));
      },
    );
  }
}
