import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class DashboardCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DashboardCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DashboardCalendar> createState() => _DashboardCalendarState();
}

class _DashboardCalendarState extends State<DashboardCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate;
  }

  @override
  void didUpdateWidget(covariant DashboardCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _focusedDay = widget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      padding: EdgeInsets.only(bottom: context.spacing.l),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,

            headerStyle: const HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
            ),

            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: context.colors.secondary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
              ),
            ),

            selectedDayPredicate: (day) => isSameDay(widget.selectedDate, day),

            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(widget.selectedDate, selectedDay)) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                widget.onDateSelected(selectedDay);
              }
            },

            onFormatChanged: (format) =>
                setState(() => _calendarFormat = format),
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
          ),
        ],
      ),
    );
  }
}
