import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/feedback_provider.dart';
import '../../providers/auth_provider.dart';
import '../../cards/feedback/feedback_message_card.dart';
import '../../cards/feedback/feedback_replies_card.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      authState.whenData((admin) {
        if (admin != null) {
          ref.read(feedbackProvider.notifier).fetchFeedbacks(admin.adminId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Feedback',
        subtitle: 'Share your thoughts and suggestions with us',
      ),
      drawer: const SideNavBar(),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              final authState = ref.read(authProvider);
              final adminId = authState.value?.adminId;
              if (adminId != null) {
                await ref.read(feedbackProvider.notifier).fetchFeedbacks(adminId);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FeedbackMessageCard(),
                  AppGaps.extraLargeV,
                  Text('Previous Feedback',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  AppGaps.largeV,
                  if (state.feedbacks.isEmpty && !state.isLoading)
                    const Center(
                        child: Text('No feedback yet.',
                            style: TextStyle(color: AppColors.darkGrey)))
                  else
                    ...state.feedbacks.map((f) => FeedbackRepliesCard(item: f)),
                ],
              ),
            ),
          ),
          if (state.isLoading)
            const Center(
                child: CircularProgressIndicator(color: AppColors.black)),
          if (state.errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error: ${state.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
