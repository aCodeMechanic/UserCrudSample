import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({Key? key}) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildCalendar(),
            const SizedBox(height: 16),
            _buildSelectedDate(),
            const SizedBox(height: 16),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 4,
      runSpacing: 4,
      children: [
        _buildQuickActionButton('Today', DateTime.now()),
        _buildQuickActionButton('Next Monday', _getNextMonday()),
        _buildQuickActionButton('Next Tuesday', _getNextTuesday()),
        _buildQuickActionButton('After 1 week', DateTime.now().add(const Duration(days: 7))),
      ],
    );
  }

  Widget _buildQuickActionButton(String text, DateTime date) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDate = date;
          _focusedDay = date;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue,
      ),
      child: SizedBox(width: MediaQuery.of(context).size.width/5,child: Center(child: Text(text,style: TextStyle(fontSize: 12),))),
    );
  }

  DateTime _getNextMonday() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int daysUntilNextMonday = (DateTime.monday - currentWeekday + 7) % 7;
    return now.add(Duration(days: daysUntilNextMonday));
  }

  DateTime _getNextTuesday() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int daysUntilNextTuesday = (DateTime.tuesday - currentWeekday + 7) % 7;
    return now.add(Duration(days: daysUntilNextTuesday));
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                });
              },
            ),
            Text(
              DateFormat('MMMM yyyy').format(_focusedDay),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDaysOfWeek(),
        _buildCalendarDays(),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text('Sun', style: TextStyle(color: Colors.grey)),
        Text('Mon', style: TextStyle(color: Colors.grey)),
        Text('Tue', style: TextStyle(color: Colors.grey)),
        Text('Wed', style: TextStyle(color: Colors.grey)),
        Text('Thu', style: TextStyle(color: Colors.grey)),
        Text('Fri', style: TextStyle(color: Colors.grey)),
        Text('Sat', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final daysBefore = firstDayOfMonth.weekday % 7;
    final totalDays = lastDayOfMonth.day + daysBefore;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalDays,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        if (index < daysBefore) {
          return const SizedBox.shrink();
        }

        final day = index - daysBefore + 1;
        final currentDate = DateTime(_focusedDay.year, _focusedDay.month, day);
        final isSelected = _selectedDate.year == currentDate.year &&
            _selectedDate.month == currentDate.month &&
            _selectedDate.day == currentDate.day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedDate() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            DateFormat('d MMM yyyy').format(_selectedDate),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedDate);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
