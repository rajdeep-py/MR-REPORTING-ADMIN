import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/announcement_notifier.dart';
import '../models/announcement.dart';

final announcementProvider = StateNotifierProvider<AnnouncementNotifier, List<Announcement>>((ref) {
  return AnnouncementNotifier();
});
