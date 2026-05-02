import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/announcement.dart';
import '../../providers/announcement_provider.dart';

class AnnouncementCard extends ConsumerWidget {
  final Announcement announcement;
  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Iconsax.notification, color: AppColors.black),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        announcement.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(announcement.createdAt),
                      style: const TextStyle(color: AppColors.darkGrey, fontSize: 12),
                    ),
                  ],
                ),
                AppGaps.smallV,
                Text(
                  announcement.description,
                  style: const TextStyle(color: AppColors.darkGrey, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              ref.read(announcementProvider.notifier).deleteAnnouncement(announcement.id);
            },
            icon: const Icon(Iconsax.trash, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
