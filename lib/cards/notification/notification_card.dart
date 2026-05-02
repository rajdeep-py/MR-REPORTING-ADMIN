import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: notification.isRead ? AppColors.white : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: notification.isRead ? AppColors.lightGrey.withAlpha(128) : AppColors.black.withAlpha(20),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification.isRead ? AppColors.surface : AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.notification_bing,
                    color: notification.isRead ? AppColors.black : AppColors.white,
                    size: 24,
                  ),
                ),
                AppGaps.mediumH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification.header,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                                  ),
                            ),
                          ),
                          Text(
                            _formatTime(notification.timestamp),
                            style: TextStyle(
                              color: notification.isRead ? AppColors.coolGrey : AppColors.black,
                              fontSize: 12,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      AppGaps.smallV,
                      Text(
                        notification.description,
                        style: const TextStyle(
                          color: AppColors.darkGrey,
                          height: 1.5,
                        ),
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

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
