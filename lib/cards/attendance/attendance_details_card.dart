import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/attendance_provider.dart';

class AttendanceDetailsCard extends ConsumerWidget {
  const AttendanceDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceProvider);
    
    if (state.selectedEmployeeId == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
        ),
        child: const Center(
          child: Text('Select an employee to view details', style: TextStyle(color: AppColors.darkGrey)),
        ),
      );
    }

    final record = state.records.where((r) => 
      r.employeeId == state.selectedEmployeeId && 
      r.date.year == state.selectedDate.year && 
      r.date.month == state.selectedDate.month && 
      r.date.day == state.selectedDate.day
    ).firstOrNull;

    final dateStr = DateFormat('MMM dd, yyyy').format(state.selectedDate);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Details for $dateStr',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (record != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: record.status == 'Present' ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    record.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: record.status == 'Present' ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                ),
            ],
          ),
          AppGaps.largeV,
          if (record != null && record.status == 'Present') ...[
            Row(
              children: [
                Expanded(child: _buildTimeBox('Check In', record.checkInTime, Iconsax.login)),
                AppGaps.mediumH,
                Expanded(child: _buildTimeBox('Check Out', record.checkOutTime, Iconsax.logout)),
              ],
            ),
            AppGaps.mediumV,
            Row(
              children: [
                Expanded(child: _buildTimeBox('Break In', record.breakInTime, Iconsax.coffee)),
                AppGaps.mediumH,
                Expanded(child: _buildTimeBox('Break Out', record.breakOutTime, Iconsax.briefcase)),
              ],
            ),
          ] else if (record != null && record.status == 'Absent') ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48.0),
              child: Center(
                child: Text('Employee was absent on this day.', style: TextStyle(color: AppColors.darkGrey)),
              ),
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48.0),
              child: Center(
                child: Text('No attendance recorded.', style: TextStyle(color: AppColors.darkGrey)),
              ),
            ),
          ],
          AppGaps.largeV,
          const Divider(color: AppColors.lightGrey),
          AppGaps.mediumV,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref.read(attendanceProvider.notifier).markAttendance('Absent'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  child: const Text('Mark Absent'),
                ),
              ),
              AppGaps.mediumH,
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ref.read(attendanceProvider.notifier).markAttendance('Present'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Mark Present'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String label, DateTime? time, IconData icon) {
    final timeStr = time != null ? DateFormat('hh:mm a').format(time) : '--:--';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
