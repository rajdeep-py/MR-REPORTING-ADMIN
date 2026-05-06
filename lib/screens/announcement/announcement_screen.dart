import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/auth_provider.dart';
import '../../cards/announcement/announcement_card.dart';
import '../../cards/announcement/create_announcement_card.dart';

class AnnouncementScreen extends ConsumerStatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  ConsumerState<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends ConsumerState<AnnouncementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authState = ref.read(authProvider);
      final adminId = authState.value?.adminId;
      if (adminId != null) {
        ref.read(announcementProvider.notifier).fetchAnnouncements(adminId);
      }
    });
  }

  void _showCreateAnnouncement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAnnouncementCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(announcementProvider);
    final authState = ref.watch(authProvider);
    final adminId = authState.value?.adminId;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Announcements',
        subtitle: 'Manage and broadcast updates',
        actions: [
          ElevatedButton.icon(
            onPressed: adminId == null ? null : () => _showCreateAnnouncement(context),
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
      body: RefreshIndicator(
        onRefresh: () async {
          if (adminId != null) {
            await ref.read(announcementProvider.notifier).fetchAnnouncements(adminId);
          }
        },
        child: state.isLoading && state.announcements.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.black))
            : state.announcements.isEmpty
                ? const Center(child: Text('No announcements yet.', style: TextStyle(color: AppColors.darkGrey)))
                : ListView.builder(
                    padding: const EdgeInsets.all(AppGaps.screenPadding),
                    itemCount: state.announcements.length,
                    itemBuilder: (context, index) {
                      return AnnouncementCard(announcement: state.announcements[index]);
                    },
                  ),
      ),
    );
  }
}
