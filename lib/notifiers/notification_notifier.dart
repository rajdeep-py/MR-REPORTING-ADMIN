import 'package:flutter_riverpod/legacy.dart';
import '../models/notification.dart';

class NotificationState {
  final List<AppNotification> notifications;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState()) {
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(
      isLoading: false,
      notifications: [
        AppNotification(
          id: 'N001',
          header: 'New Employee Registration',
          description:
              'Dr. John Doe has successfully registered and requires approval.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        AppNotification(
          id: 'N002',
          header: 'Monthly Target Reached',
          description: 'Team Alpha has achieved 100% of their monthly target.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        AppNotification(
          id: 'N003',
          header: 'System Maintenance',
          description:
              'Server will undergo maintenance at 12:00 AM tonight. Expect 15 mins of downtime.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
      ],
    );
  }

  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  void markAllAsRead() {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    state = state.copyWith(notifications: updated);
  }
}
