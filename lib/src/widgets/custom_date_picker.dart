import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_crud_sample/theme/theme.dart';

class CustomDatePicker extends StatefulWidget {
  bool allowNoDate;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedDate;

  CustomDatePicker(
      {Key? key,
      this.allowNoDate = false,
      this.startDate,
      this.endDate,
      this.selectedDate})
      : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool _showYearPicker = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate;
      _focusedDay = widget.selectedDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(        maxWidth: 500,
          maxHeight: 800,),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuickActions(),
                const SizedBox(height: 16),
                _showYearPicker ? _buildYearPicker() : _buildCalendar(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSelectedDate(),
                    Spacer(),
                    _buildButtons(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    List<Widget> actions = [];

    if (widget.allowNoDate) {
      actions.add(_buildQuickActionButton('No date', null));
    }

    actions.add(_buildQuickActionButton('Today', DateTime.now()));
    if (!widget.allowNoDate) {
      actions.addAll([
        _buildQuickActionButton('Next Monday', _getNextMonday()),
        _buildQuickActionButton('Next Tuesday', _getNextTuesday()),
        _buildQuickActionButton(
            'After 1 week', DateTime.now().add(const Duration(days: 7))),
      ]);
    }
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = 2;
      if (constraints.maxWidth > 600) {
        // Example breakpoint
        crossAxisCount = 4;
      }
      return GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 4.5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          children: actions);
    });
  }

  Widget _buildQuickActionButton(String text, DateTime? date) {
    return ElevatedButton(
      onPressed: () {
        _selectedDate = date;
        setState(() {
          if (date != null) {
            _focusedDay = date;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        foregroundColor: primaryColor,
      ),
      child: Center(
          child: Text(
        text,
      )),
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

  Widget _buildYearPicker() {
    return SizedBox(
      height: 200,
      child: YearPicker(
        firstDate: DateTime(DateTime.now().year - 100, 1),
        lastDate: DateTime(DateTime.now().year + 100, 1),
        initialDate: _focusedDay,
        selectedDate: _focusedDay,
        onChanged: (DateTime dateTime) {
          setState(() {
            _focusedDay = dateTime;
            _showYearPicker = false;
          });
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_left,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                      _focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showYearPicker = true;
                });
              },
              child: Text(
                DateFormat('MMMM yyyy').format(_focusedDay),
                style: textTheme(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_right,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                      _focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
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
      children: [
        Text('Sun', style: textTheme(color: Colors.grey)),
        Text('Mon', style: textTheme(color: Colors.grey)),
        Text('Tue', style: textTheme(color: Colors.grey)),
        Text('Wed', style: textTheme(color: Colors.grey)),
        Text('Thu', style: textTheme(color: Colors.grey)),
        Text('Fri', style: textTheme(color: Colors.grey)),
        Text('Sat', style: textTheme(color: Colors.grey)),
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

        // Disable dates before startDate
        if (widget.startDate != null &&
            currentDate.isBefore(widget.startDate!)) {
          return _buildDisabledCalendarDay(day);
        }

        // Disable dates after endDate
        if (widget.endDate != null && currentDate.isAfter(widget.endDate!)) {
          return _buildDisabledCalendarDay(day);
        }

        final isSelected = _selectedDate != null &&
            _selectedDate?.year == currentDate.year &&
            _selectedDate?.month == currentDate.month &&
            _selectedDate?.day == currentDate.day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: textTheme(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDisabledCalendarDay(int day) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Center(
        child: Text(
          '$day',
          style: textTheme(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDate() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_month, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            _selectedDate != null
                ? DateFormat('d MMM yyyy').format(_selectedDate!)
                : "No Date",
            style: textTheme(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedDate);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
