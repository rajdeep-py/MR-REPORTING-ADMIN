import 'package:flutter_riverpod/legacy.dart';
import '../models/announcement.dart';
import '../services/announcement/announcement_services.dart';

class AnnouncementState {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? error;

  AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
    this.error,
  });

  AnnouncementState copyWith({
    List<Announcement>? announcements,
    bool? isLoading,
    String? error,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AnnouncementNotifier extends StateNotifier<AnnouncementState> {
  final AnnouncementServices _services = AnnouncementServices();

  AnnouncementNotifier() : super(AnnouncementState());

  Future<void> fetchAnnouncements(String adminId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final announcements = await _services.getAnnouncementsByAdmin(adminId);
      state = state.copyWith(announcements: announcements, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<bool> addAnnouncement({
    required String adminId,
    required String title,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newAnnouncement = await _services.createAnnouncement(
        adminId: adminId,
        title: title,
        description: description,
      );
      if (newAnnouncement != null) {
        state = state.copyWith(
          announcements: [newAnnouncement, ...state.announcements],
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateAnnouncement({
    required String announcementId,
    String? title,
    String? description,
    String? status,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updated = await _services.updateAnnouncement(
        announcementId: announcementId,
        title: title,
        description: description,
        status: status,
      );
      if (updated != null) {
        state = state.copyWith(
          announcements: state.announcements
              .map((a) => a.id == announcementId ? updated : a)
              .toList(),
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteAnnouncement(String announcementId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _services.deleteAnnouncement(announcementId);
      if (success) {
        state = state.copyWith(
          announcements: state.announcements.where((a) => a.id != announcementId).toList(),
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }
}
