import 'database.dart';

class EmployeeDao {
  final AppDatabase db;

  EmployeeDao(this.db);

  Future<List<EmployeeData>> getAllEmployees() => db.select(db.employee).get(); // Updated to db.employee

  Future<int> insertEmployee(EmployeeCompanion employee) => db.into(db.employee).insert(employee); // Updated to db.employee

  Future<bool> updateEmployee(EmployeeData employee) => db.update(db.employee).replace(employee); // Updated to db.employee

  Future<int> deleteEmployee(EmployeeData employee) => db.delete(db.employee).delete(employee); // Updated to db.employee

  // New method to get non-deleted employees
  Future<List<EmployeeData>> getActiveEmployees() {
    return (db.select(db.employee)
      ..where((t) => t.isDeleted.equals(false))) // Only get non-deleted
        .get();
  }
}
