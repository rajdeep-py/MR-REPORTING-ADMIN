import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/feedback.dart';

class FeedbackRepliesCard extends StatelessWidget {
  final FeedbackItem item;
  const FeedbackRepliesCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.surface,
                child: Icon(Iconsax.user, color: AppColors.black, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('You', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        Text(DateFormat('MMM dd, yyyy').format(item.createdAt), style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                      ],
                    ),
                    AppGaps.smallV,
                    Text(item.message, style: const TextStyle(color: AppColors.black, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          if (item.replyMessage != null) ...[
            AppGaps.largeV,
            const Divider(color: AppColors.lightGrey),
            AppGaps.largeV,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.black,
                  child: Icon(Iconsax.verify, color: AppColors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Naiyo24', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.black)),
                          if (item.repliedAt != null)
                            Text(DateFormat('MMM dd, yyyy').format(item.repliedAt!), style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                        ],
                      ),
                      AppGaps.smallV,
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16).copyWith(topLeft: const Radius.circular(0)),
                        ),
                        child: Text(item.replyMessage!, style: const TextStyle(color: AppColors.darkGrey, height: 1.5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
