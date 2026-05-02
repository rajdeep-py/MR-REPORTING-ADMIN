import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/feedback_notifier.dart';
import '../models/feedback.dart';

final feedbackProvider = StateNotifierProvider<FeedbackNotifier, List<FeedbackItem>>((ref) {
  return FeedbackNotifier();
});
