import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../main.dart'; // Import for AppColors

class DatePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const DatePicker({super.key, this.initialStartDate, this.initialEndDate});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialStartDate;
    _rangeEnd = widget.initialEndDate;
    if (_rangeStart != null) _focusedDay = _rangeStart!;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_rangeStart, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        if (_rangeStart == null || _rangeEnd != null) {
          // Start a new range
          _rangeStart = selectedDay;
          _rangeEnd = null;
        } else if (selectedDay.isBefore(_rangeStart!)) {
          // If selected day is before start day, make it the new start day
          _rangeEnd = _rangeStart;
          _rangeStart = selectedDay;
        } else {
          // If selected day is after start day, make it the end day
          _rangeEnd = selectedDay;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    return DateFormat('MMM dd\nEEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    int nightCount = 0;
    if (_rangeStart != null && _rangeEnd != null) {
      nightCount = _rangeEnd!.difference(_rangeStart!).inDays;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Select Dates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 20),
          // Date Summary Display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(border: Border.all(color: AppColors.primaryBlue), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(child: _buildDateSummary("CHECK-IN", _rangeStart)),
                Container(width: 1, height: 40, color: AppColors.inputBorder),
                Expanded(child: _buildDateSummary("CHECK-OUT", _rangeEnd)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (nightCount > 0) Text("$nightCount nights selected", style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // Calendar
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_rangeStart, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: CalendarFormat.month,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              onDaySelected: _onDaySelected,
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _rangeStart = start;
                  _rangeEnd = end;
                });
              },
              calendarStyle: const CalendarStyle(
                rangeHighlightColor: Color(0xFFD6E4FF), // Light blue range
                selectedDecoration: BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                rangeStartDecoration: BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                rangeEndDecoration: BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: AppColors.primaryBlue))),
                todayTextStyle: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
              ),
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            ),
          ),
          // Confirm Button
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (_rangeStart != null && _rangeEnd != null)
                ? () {
              // Return start and end dates as a list
              Navigator.pop(context, [_rangeStart, _rangeEnd]);
            }
                : null, // Disable if dates aren't selected
            child: const Text("CONFIRM DATES"),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSummary(String label, DateTime? date) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        const SizedBox(height: 4),
        Text(_formatDate(date), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}