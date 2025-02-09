import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_crud_sample/src/employee_details/widgets/employee_card.dart';
import '../employee_details/employee_details_screen.dart';
import 'bloc/employee_bloc.dart';
import 'package:user_crud_sample/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Employee List'), // Keep the title consistent
          ),
          backgroundColor: greyBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(

              child: Builder(
                builder: (context) {
                  if (state is EmployeeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EmployeeLoaded) {
                    if (state.employees.isEmpty) {
                      // Show the image and text when no employees are found.
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/not_found.png',
                                // Replace with your image path.  Add the image to assets
                                width: 200, // Adjust the size as needed
                                height: 200,
                              ),
                              const SizedBox(height: 16),
                              Text('No employee records found.',
                                  style: textTheme(fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    }

                    // Filter employees into current and previous
                    final currentEmployees =
                    state.employees.where((emp) => emp.endDate == null).toList();
                    final previousEmployees =
                    state.employees.where((emp) => emp.endDate != null).toList();

                    return Stack(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          children: [
                            if (currentEmployees.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Current Employees',
                                    style: textTheme(
                                        fontSize: 16, fontWeight: FontWeight.bold,color: primaryColor)),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // Disable scrolling for nested ListView
                                itemCount: currentEmployees.length,
                                itemBuilder: (context, index) {
                                  return EmployeeCard(
                                      employee: currentEmployees[index]);
                                },
                              ),
                            ],
                            if (previousEmployees.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Previous Employees',
                                    style: textTheme(
                                        fontSize: 16, fontWeight: FontWeight.bold,color: primaryColor)),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // Disable scrolling for nested ListView
                                itemCount: previousEmployees.length,
                                itemBuilder: (context, index) {
                                  return EmployeeCard(
                                      employee: previousEmployees[index]);
                                },
                              ),
                              SizedBox(height: 50,),
                            ],
                          ],
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(color:greyBackgroundColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(height: 2,color: Colors.white,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30.0, top: 15, bottom: 15),
                                    child: Text('Swipe left to delete'),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    );
                  } else if (state is EmployeeError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const Center(
                        child: Text('Initial State')); // Handle initial state
                  }
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // Navigate to the EmployeeDetailsScreen for adding a new employee
              var value = await Navigator.push(
                context,
                MaterialPageRoute(maintainState: true,
                  builder: (context) =>
                      EmployeeDetailsScreen(
                          employee: null), // Pass null for new employee
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
