import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/employee_provider.dart';
import '../../cards/routine/routine_filter_card.dart';
import '../../cards/routine/routine_details_card.dart';
import '../../routes/app_router.dart';

class RoutineDetailScreen extends ConsumerWidget {
  final String id;
  const RoutineDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeProvider);
    
    final employeeExists = employeeState.employees.any((e) => e.id == id);
    if (!employeeExists) {
      return const Scaffold(body: Center(child: Text('Employee not found')));
    }

    final employee = employeeState.employees.firstWhere((e) => e.id == id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Routine Schedule',
        subtitle: 'View and manage routines',
        showBackButton: true,
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.push('${AppRouter.createRoutine}/$id'),
            icon: const Icon(Iconsax.add, size: 18),
            label: const Text('Create New Routine'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const RoutineFilterCard(),
            AppGaps.largeV,
            RoutineDetailsCard(employee: employee),
          ],
        ),
      ),
    );
  }
}
