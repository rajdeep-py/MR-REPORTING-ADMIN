import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/feedback_provider.dart';
import '../../cards/feedback/feedback_message_card.dart';
import '../../cards/feedback/feedback_replies_card.dart';

class FeedbackScreen extends ConsumerWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbacks = ref.watch(feedbackProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Feedback',
        subtitle: 'Share your thoughts and suggestions with us',
      ),
      drawer: const SideNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FeedbackMessageCard(),
            AppGaps.extraLargeV,
            Text('Previous Feedback', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            AppGaps.largeV,
            if (feedbacks.isEmpty)
              const Center(child: CircularProgressIndicator(color: AppColors.black))
            else
              ...feedbacks.map((f) => FeedbackRepliesCard(item: f)),
          ],
        ),
      ),
    );
  }
}
