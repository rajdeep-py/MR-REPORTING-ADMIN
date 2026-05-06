import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/gift.dart';
import '../../providers/gift_provider.dart';

class GiftCard extends ConsumerWidget {
  final GiftItem item;
  final VoidCallback? onEdit;
  const GiftCard({super.key, required this.item, this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Iconsax.gift, color: AppColors.black, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.giftItemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.giftItemDescription,
                  style: const TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹${item.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch.adaptive(
                      value: item.status == 'active',
                      activeColor: AppColors.success,
                      onChanged: (value) async {
                        final newStatus = value ? 'active' : 'inactive';
                        await ref
                            .read(giftProvider.notifier)
                            .updateGiftItem(item.giftId, {
                          'status': newStatus,
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              InkWell(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.edit,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Gift'),
                      content: const Text(
                        'Are you sure you want to delete this gift?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref
                        .read(giftProvider.notifier)
                        .deleteGiftItem(item.giftId);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.trash,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
