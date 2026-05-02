import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/announcement_provider.dart';
import '../../cards/announcement/announcement_card.dart';
import '../../cards/announcement/create_announcement_card.dart';

class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  void _showCreateAnnouncement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAnnouncementCard(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Announcements',
        subtitle: 'Manage and broadcast updates',
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showCreateAnnouncement(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const SideNavBar(),
      body: announcements.isEmpty
          ? const Center(child: Text('No announcements yet.', style: TextStyle(color: AppColors.darkGrey)))
          : ListView.builder(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                return AnnouncementCard(announcement: announcements[index]);
              },
            ),
    );
  }
}
