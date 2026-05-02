import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/team_provider.dart';
import '../../cards/team/team_card.dart';
import '../../cards/team/team_search_card.dart';
import '../../routes/app_router.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teamProvider);

    final filteredTeams = state.teams.where((team) {
      if (state.searchQuery.isEmpty) return true;
      return team.name.toLowerCase().contains(state.searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Team Management',
        subtitle: 'Manage sales units and representatives',
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.push(AppRouter.createEditTeam),
            icon: const Icon(Iconsax.add, size: 18),
            label: const Text('Create New Team'),
          ),
        ],
      ),
      drawer: const SideNavBar(),
      body: state.isLoading && state.teams.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.black),
            )
          : Padding(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: Column(
                children: [
                  const TeamSearchCard(),
                  AppGaps.largeV,
                  Expanded(
                    child: filteredTeams.isEmpty
                        ? const Center(
                            child: Text(
                              'No teams found',
                              style: TextStyle(color: AppColors.darkGrey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredTeams.length,
                            itemBuilder: (context, index) {
                              return TeamCard(team: filteredTeams[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
