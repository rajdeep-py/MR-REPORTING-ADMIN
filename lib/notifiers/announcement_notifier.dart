import 'package:flutter_riverpod/legacy.dart';
import '../models/announcement.dart';

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  AnnouncementNotifier() : super([]) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    state = [
      Announcement(
        id: '1',
        title: 'Q3 Townhall Meeting',
        description: 'All medical representatives are requested to attend the Q3 Townhall meeting next Friday. We will discuss the new product line and revised targets.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Announcement(
        id: '2',
        title: 'New Policy Updates',
        description: 'Please review the updated expense reimbursement policies uploaded on the portal. These changes will be effective from next month.',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  void addAnnouncement(String title, String description) {
    final newItem = Announcement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    state = [newItem, ...state];
  }

  void deleteAnnouncement(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}
