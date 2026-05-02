import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/team_provider.dart';
import '../../providers/employee_provider.dart';
import '../../routes/app_router.dart';

class TeamDetailsScreen extends ConsumerWidget {
  final String id;
  const TeamDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider);
    final employeeState = ref.watch(employeeProvider);

    final teamExists = teamState.teams.any((t) => t.id == id);
    if (!teamExists) {
      return const Scaffold(body: Center(child: Text('Team not found')));
    }

    final team = teamState.teams.firstWhere((t) => t.id == id);
    
    // Get members
    final members = team.memberIds.map((memId) {
      try {
        return employeeState.employees.firstWhere((e) => e.id == memId);
      } catch (_) {
        return null;
      }
    }).where((e) => e != null).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Team Details',
        subtitle: team.name,
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: () => context.push('${AppRouter.createEditTeam}/$id'),
            icon: const Icon(Iconsax.edit_2, color: AppColors.black),
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(context, ref),
            icon: const Icon(Iconsax.trash, color: AppColors.error),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTeamHeader(context, team),
            AppGaps.largeV,
            Text(
              'Team Members (${members.length})', 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)
            ),
            AppGaps.mediumV,
            if (members.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(child: Text('No members in this team.', style: TextStyle(color: AppColors.darkGrey))),
              )
            else
              ...members.map((m) => _buildMemberCard(context, m!)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader(BuildContext context, team) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black.withAlpha(51), width: 2),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surface,
              backgroundImage: team.photoPath != null ? FileImage(File(team.photoPath!)) : null,
              child: team.photoPath == null ? const Icon(Iconsax.people, size: 40, color: AppColors.black) : null,
            ),
          ),
          AppGaps.largeV,
          Text(team.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          AppGaps.mediumV,
          Text(team.description, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.darkGrey)),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, employee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: employee.profilePhotoPath != null ? FileImage(File(employee.profilePhotoPath!)) : null,
            child: employee.profilePhotoPath == null ? const Icon(Iconsax.user, size: 20) : null,
          ),
          AppGaps.mediumH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text(employee.headquarter, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: const Text('Are you sure you want to delete this team?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(teamProvider.notifier).deleteTeam(id);
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
