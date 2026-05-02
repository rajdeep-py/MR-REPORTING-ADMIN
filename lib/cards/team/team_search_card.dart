import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/team_provider.dart';

class TeamSearchCard extends ConsumerWidget {
  const TeamSearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: TextField(
        onChanged: (val) => ref.read(teamProvider.notifier).setSearchQuery(val),
        decoration: const InputDecoration(
          hintText: 'Search teams by name...',
          prefixIcon: Icon(Iconsax.search_normal),
        ),
      ),
    );
  }
}
