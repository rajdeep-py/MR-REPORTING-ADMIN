import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_theme.dart';
import '../../providers/attendance_provider.dart';

class AttendanceCalendarCard extends ConsumerWidget {
  const AttendanceCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceProvider);
    final selectedEmpId = state.selectedEmployeeId;

    final empRecords = state.records.where((r) => r.employeeId == selectedEmpId).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: state.selectedDate,
        currentDay: state.selectedDate,
        selectedDayPredicate: (day) => isSameDay(state.selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          ref.read(attendanceProvider.notifier).selectDate(selectedDay);
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final record = empRecords.where((r) => isSameDay(r.date, date)).firstOrNull;
            if (record != null) {
              return Positioned(
                bottom: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: record.status == 'Present' ? Colors.green : Colors.red,
                  ),
                ),
              );
            }
            return null;
          },
        ),
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.lightGrey,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
