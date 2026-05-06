import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/feedback_provider.dart';
import '../../providers/auth_provider.dart';

class FeedbackMessageCard extends ConsumerStatefulWidget {
  const FeedbackMessageCard({super.key});

  @override
  ConsumerState<FeedbackMessageCard> createState() =>
      _FeedbackMessageCardState();
}

class _FeedbackMessageCardState extends ConsumerState<FeedbackMessageCard> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final authState = ref.read(authProvider);
      final adminId = authState.value?.adminId;

      if (adminId != null) {
        final success = await ref
            .read(feedbackProvider.notifier)
            .submitFeedback(adminId, text);
        if (success && mounted) {
          _controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback submitted successfully!'),
              backgroundColor: AppColors.black,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Iconsax.message_edit, color: AppColors.black),
              ),
              const SizedBox(width: 16),
              Text('Share Your Feedback', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          AppGaps.largeV,
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind? Tell us how we can improve...',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          AppGaps.largeV,
          Align(
            alignment: Alignment.centerRight,
            child: Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(feedbackProvider).isLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.send_1, size: 18),
                            SizedBox(width: 8),
                            Text('Submit Feedback', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
