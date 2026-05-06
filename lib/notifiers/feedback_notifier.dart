import 'package:flutter_riverpod/legacy.dart';
import '../models/feedback.dart';
import '../services/feedback/feedback_services.dart';

class FeedbackState {
  final List<FeedbackItem> feedbacks;
  final bool isLoading;
  final String? errorMessage;

  FeedbackState({
    this.feedbacks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FeedbackState copyWith({
    List<FeedbackItem>? feedbacks,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FeedbackState(
      feedbacks: feedbacks ?? this.feedbacks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class FeedbackNotifier extends StateNotifier<FeedbackState> {
  final FeedbackServices _services = FeedbackServices();

  FeedbackNotifier() : super(FeedbackState());

  Future<void> fetchFeedbacks(String adminId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final feedbacks = await _services.getFeedbackByAdmin(adminId);
      state = state.copyWith(feedbacks: feedbacks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> submitFeedback(String adminId, String message) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final newFeedback = await _services.createFeedback({
        'admin_id': adminId,
        'feedback_message': message,
      });
      state = state.copyWith(
        feedbacks: [newFeedback, ...state.feedbacks],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteFeedback(String feedbackId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final success = await _services.deleteFeedback(feedbackId);
      if (success) {
        state = state.copyWith(
          feedbacks: state.feedbacks.where((f) => f.feedbackId != feedbackId).toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Delete failed');
      }
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
