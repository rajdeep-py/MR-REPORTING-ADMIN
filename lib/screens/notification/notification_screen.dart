import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/notification_provider.dart';
import '../../cards/notification/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Notifications',
        subtitle: 'Stay updated with your latest alerts',
        actions: [
          TextButton.icon(
            onPressed: () => ref.read(notificationProvider.notifier).markAllAsRead(),
            icon: const Icon(Iconsax.tick_circle, color: AppColors.black),
            label: const Text('Mark all as read', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      drawer: const SideNavBar(),
      body: state.isLoading && state.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
          : Padding(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: state.notifications.isEmpty
                  ? const Center(child: Text('No notifications right now', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () {
                            ref.read(notificationProvider.notifier).markAsRead(notification.id);
                          },
                        );
                      },
                    ),
            ),
    );
  }
}
