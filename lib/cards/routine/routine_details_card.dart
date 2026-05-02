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
            icon: const Icon(Iconsax.edit_2, size: 18),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => _EditTaskDialog(routineId: routineId, task: task, ref: ref),
              );
            },
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

class _EditTaskDialog extends StatefulWidget {
  final String routineId;
  final RoutineTask task;
  final WidgetRef ref;

  const _EditTaskDialog({required this.routineId, required this.task, required this.ref});

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late String _timeStr;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title);
    _descCtrl = TextEditingController(text: widget.task.description);
    _timeStr = widget.task.time;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final now = TimeOfDay.now();
    final initialTime = TimeOfDay(
      hour: int.tryParse(_timeStr.split(':')[0]) ?? now.hour,
      minute: int.tryParse(_timeStr.split(':')[1].split(' ')[0]) ?? now.minute,
    );
    
    final time = await showTimePicker(context: context, initialTime: initialTime);
    if (time != null && mounted) {
      setState(() {
        _timeStr = time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Edit Task', style: TextStyle(fontWeight: FontWeight.w700)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Task Title', prefixIcon: Icon(Iconsax.task_square)),
            ),
            AppGaps.mediumV,
            TextField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Task Description', prefixIcon: Icon(Iconsax.text_block)),
            ),
            AppGaps.mediumV,
            InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface, 
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.clock, size: 18),
                    const SizedBox(width: 8),
                    Text(_timeStr, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.darkGrey)),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = widget.task.copyWith(
              title: _titleCtrl.text,
              description: _descCtrl.text,
              time: _timeStr,
            );
            widget.ref.read(routineProvider.notifier).updateTask(widget.routineId, updated);
            Navigator.of(context).pop();
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}

