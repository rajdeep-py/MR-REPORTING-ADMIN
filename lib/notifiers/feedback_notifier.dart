import 'package:flutter_riverpod/legacy.dart';
import '../models/feedback.dart';

class FeedbackNotifier extends StateNotifier<List<FeedbackItem>> {
  FeedbackNotifier() : super([]) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    state = [
      FeedbackItem(
        id: '1',
        message:
            'The new analytics dashboard is great, but it would be helpful to export the reports as PDF.',
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
        replyMessage:
            'Thank you for your feedback! We are currently working on adding PDF and Excel export features in the upcoming release.',
        repliedAt: now.subtract(const Duration(days: 1)),
      ),
      FeedbackItem(
        id: '2',
        message:
            'Can we add an option to filter employees by region in the attendance tab?',
        createdAt: now.subtract(const Duration(days: 5)),
        replyMessage:
            'Great suggestion! We have noted this down and will discuss it with the product team.',
        repliedAt: now.subtract(const Duration(days: 4)),
      ),
      FeedbackItem(
        id: '3',
        message:
            'There seems to be a minor delay when syncing large expense receipts.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }

  void submitFeedback(String message) {
    final newItem = FeedbackItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      createdAt: DateTime.now(),
    );
    state = [newItem, ...state];
  }
}
