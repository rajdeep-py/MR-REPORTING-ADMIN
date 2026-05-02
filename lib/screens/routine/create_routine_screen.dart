import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/routine_provider.dart';
import '../../providers/employee_provider.dart';
import '../../models/routine.dart';

class CreateRoutineScreen extends ConsumerStatefulWidget {
  final String employeeId;
  const CreateRoutineScreen({super.key, required this.employeeId});

  @override
  ConsumerState<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends ConsumerState<CreateRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final List<DateTime> _selectedDates = [];
  final List<RoutineTask> _tasks = [];
  
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  void _addDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && !_selectedDates.contains(date)) {
      setState(() {
        _selectedDates.add(date);
        _selectedDates.sort();
      });
    }
  }

  void _addTask() {
    if (_titleCtrl.text.isEmpty) return;
    
    final timeStr = _selectedTime.format(context);
    
    setState(() {
      _tasks.add(RoutineTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        time: timeStr,
      ));
      _titleCtrl.clear();
      _descCtrl.clear();
    });
  }

  void _save() {
    if (_selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one date.')));
      return;
    }
    if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one task.')));
      return;
    }

    final notifier = ref.read(routineProvider.notifier);
    
    for (var date in _selectedDates) {
      notifier.addRoutine(Routine(
        id: DateTime.now().millisecondsSinceEpoch.toString() + date.day.toString(),
        employeeId: widget.employeeId,
        date: date,
        tasks: List.from(_tasks),
      ));
    }
    
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeProvider);
    final employee = employeeState.employees.firstWhere((e) => e.id == widget.employeeId);

    final isDesktop = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Create Routine',
        subtitle: 'For ${employee.fullName}',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Form(
          key: _formKey,
          child: isDesktop 
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildDatesCard()),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildTasksBuilderCard(),
                        AppGaps.largeV,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: _save, child: const Text('Save Routine')),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildDatesCard(),
                  AppGaps.largeV,
                  _buildTasksBuilderCard(),
                  AppGaps.largeV,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: _save, child: const Text('Save Routine')),
                  ),
                ],
            ),
        ),
      ),
    );
  }

  Widget _buildDatesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Selected Dates', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              IconButton(
                onPressed: _addDate,
                icon: const Icon(Iconsax.add_circle),
                color: AppColors.black,
              ),
            ],
          ),
          AppGaps.mediumV,
          if (_selectedDates.isEmpty)
            const Text('No dates selected', style: TextStyle(color: AppColors.darkGrey))
          else
            ..._selectedDates.map((d) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('MMM dd, yyyy').format(d), style: const TextStyle(fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: () => setState(() => _selectedDates.remove(d)),
                    child: const Icon(Iconsax.close_circle, size: 18, color: AppColors.error),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildTasksBuilderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Builder', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          AppGaps.largeV,
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(hintText: 'Task Title', prefixIcon: Icon(Iconsax.task_square)),
                ),
              ),
              AppGaps.mediumH,
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    final time = await showTimePicker(context: context, initialTime: _selectedTime);
                    if (time != null) setState(() => _selectedTime = time);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.clock, size: 18),
                        const SizedBox(width: 8),
                        Text(_selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppGaps.mediumV,
          TextFormField(
            controller: _descCtrl,
            maxLines: 2,
            decoration: const InputDecoration(hintText: 'Task Description (Optional)', prefixIcon: Icon(Iconsax.text_block)),
          ),
          AppGaps.mediumV,
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _addTask,
              icon: const Icon(Iconsax.add),
              label: const Text('Add Task to List'),
            ),
          ),
          AppGaps.extraLargeV,
          const Divider(color: AppColors.lightGrey),
          AppGaps.largeV,
          Text('Tasks to be Added (${_tasks.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          AppGaps.mediumV,
          if (_tasks.isEmpty)
            const Text('No tasks added yet.', style: TextStyle(color: AppColors.darkGrey))
          else
            ..._tasks.map((t) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
                    child: Text(t.time, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                  AppGaps.mediumH,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                        if (t.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(t.description, style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.trash, color: AppColors.error),
                    onPressed: () => setState(() => _tasks.remove(t)),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}
