import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/employee.dart';
import '../../models/routine.dart';
import '../../providers/routine_provider.dart';

class RoutineDetailsCard extends ConsumerWidget {
  final Employee employee;
  const RoutineDetailsCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routineProvider);
    
    // Filter routines by date range and employee
    final routines = state.routines.where((r) {
      if (r.employeeId != employee.id) return false;
      if (state.startDate != null && r.date.isBefore(state.startDate!)) return false;
      if (state.endDate != null && r.date.isAfter(state.endDate!)) return false;
      return true;
    }).toList();
    
    // Sort routines by date
    routines.sort((a, b) => a.date.compareTo(b.date));

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmployeeHeader(context),
          AppGaps.extraLargeV,
          const Divider(color: AppColors.lightGrey),
          AppGaps.largeV,
          Text('Routine Schedule', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          AppGaps.largeV,
          if (routines.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: Text('No routines scheduled for this period.', style: TextStyle(color: AppColors.darkGrey))),
            )
          else
            ...routines.map((routine) => _buildRoutineDay(context, ref, routine)),
        ],
      ),
    );
  }

  Widget _buildEmployeeHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.surface,
          backgroundImage: employee.profilePhotoPath != null ? FileImage(File(employee.profilePhotoPath!)) : null,
          child: employee.profilePhotoPath == null ? const Icon(Iconsax.user, size: 30, color: AppColors.black) : null,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.fullName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              AppGaps.smallV,
              Row(
                children: [
                  const Icon(Iconsax.location, size: 16, color: AppColors.darkGrey),
                  const SizedBox(width: 4),
                  Text(employee.headquarter, style: const TextStyle(color: AppColors.darkGrey)),
                  const SizedBox(width: 16),
                  const Icon(Iconsax.call, size: 16, color: AppColors.darkGrey),
                  const SizedBox(width: 4),
                  Text(employee.phoneNo, style: const TextStyle(color: AppColors.darkGrey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineDay(BuildContext context, WidgetRef ref, Routine routine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(12)),
            child: Text(
              DateFormat('EEEE, MMM dd, yyyy').format(routine.date),
              style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          if (routine.tasks.isEmpty)
            const Text('No tasks assigned.', style: TextStyle(color: AppColors.darkGrey))
          else
            ...routine.tasks.map((task) => _buildTaskItem(context, ref, routine.id, task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, WidgetRef ref, String routineId, RoutineTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
            child: Text(task.time, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          AppGaps.mediumH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text(task.description, style: const TextStyle(color: AppColors.darkGrey, height: 1.4)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.trash, size: 18, color: AppColors.error),
            onPressed: () {
              ref.read(routineProvider.notifier).deleteTask(routineId, task.id);
            },
          ),
        ],
      ),
    );
  }
}
