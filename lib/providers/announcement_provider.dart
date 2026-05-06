import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/announcement_notifier.dart';

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, AnnouncementState>((ref) {
  return AnnouncementNotifier();
});
