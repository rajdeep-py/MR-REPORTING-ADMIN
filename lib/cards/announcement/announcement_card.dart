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

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Announcement'),
        content: const Text('Are you sure you want to delete this announcement?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final success = await ref.read(announcementProvider.notifier).deleteAnnouncement(announcement.id);
              if (success) {
                if (!context.mounted) return;
                Navigator.pop(context);
                AppTheme.showPremiumSnackBar(context: context, message: 'Announcement deleted.');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleStatus(WidgetRef ref) async {
    final newStatus = announcement.status == 'active' ? 'inactive' : 'active';
    await ref.read(announcementProvider.notifier).updateAnnouncement(
      announcementId: announcement.id,
      status: newStatus,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isActive = announcement.status == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
            child: Icon(
              isActive ? Iconsax.notification : Iconsax.notification_status,
              color: isActive ? AppColors.black : AppColors.midGrey,
            ),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: isActive ? null : TextDecoration.lineThrough,
                          color: isActive ? AppColors.black : AppColors.midGrey,
                        ),
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
                  style: TextStyle(
                    color: isActive ? AppColors.darkGrey : AppColors.midGrey,
                    height: 1.5,
                  ),
                ),
                AppGaps.mediumV,
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleStatus(ref),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green.withAlpha(26) : AppColors.error.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive ? Colors.green.withAlpha(50) : AppColors.error.withAlpha(50),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              announcement.status.toUpperCase(),
                              style: TextStyle(
                                color: isActive ? Colors.green : AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _confirmDelete(context, ref),
                      icon: const Icon(Iconsax.trash, color: AppColors.error, size: 20),
                      tooltip: 'Delete Announcement',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
