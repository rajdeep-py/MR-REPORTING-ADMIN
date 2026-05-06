import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/feedback_notifier.dart';
import '../models/feedback.dart';

final feedbackProvider =
    StateNotifierProvider<FeedbackNotifier, FeedbackState>((ref) {
  return FeedbackNotifier();
});
