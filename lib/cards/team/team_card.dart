import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/team.dart';
import '../../routes/app_router.dart';

class TeamCard extends StatelessWidget {
  final Team team;
  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push('${AppRouter.teamDetails}/${team.id}'),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.surface,
                  backgroundImage: team.photoPath != null ? FileImage(File(team.photoPath!)) : null,
                  child: team.photoPath == null ? const Icon(Iconsax.people, color: AppColors.black) : null,
                ),
                AppGaps.mediumH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      AppGaps.smallV,
                      Text(
                        team.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                ),
                AppGaps.mediumH,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.user, size: 14, color: AppColors.black),
                      const SizedBox(width: 4),
                      Text(
                        '${team.memberIds.length} Members',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
