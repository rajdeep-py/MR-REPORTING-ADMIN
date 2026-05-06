import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/gift.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/gift_provider.dart';
import '../../providers/auth_provider.dart';
import '../../cards/gift/gift_card.dart';

class GiftInventoryScreen extends ConsumerStatefulWidget {
  const GiftInventoryScreen({super.key});

  @override
  ConsumerState<GiftInventoryScreen> createState() =>
      _GiftInventoryScreenState();
}

class _GiftInventoryScreenState extends ConsumerState<GiftInventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      authState.whenData((admin) {
        if (admin != null) {
          ref.read(giftProvider.notifier).fetchGifts(admin.adminId);
        }
      });
    });
  }

  void _showGiftModal({GiftItem? gift}) {
    final nameCtrl = TextEditingController(text: gift?.giftItemName);
    final descCtrl = TextEditingController(text: gift?.giftItemDescription);
    final priceCtrl = TextEditingController(text: gift?.price.toString());
    final statusCtrl = TextEditingController(text: gift?.status ?? 'active');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gift == null ? 'Add New Gift' : 'Edit Gift',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppGaps.largeV,
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Gift Name',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              AppGaps.mediumV,
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              AppGaps.mediumV,
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              AppGaps.mediumV,
              TextField(
                controller: statusCtrl,
                decoration: InputDecoration(
                  labelText: 'Status (active/inactive)',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              AppGaps.extraLargeV,
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Consumer(
                  builder: (context, ref, child) {
                    final isLoading = ref.watch(giftProvider).isLoading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              final name = nameCtrl.text.trim();
                              final desc = descCtrl.text.trim();
                              final price =
                                  double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                              final status = statusCtrl.text.trim();

                              final authState = ref.read(authProvider);
                              final adminId = authState.value?.adminId;

                              if (name.isNotEmpty && adminId != null) {
                                bool success;
                                if (gift == null) {
                                  success = await ref
                                      .read(giftProvider.notifier)
                                      .addGiftItem({
                                        'admin_id': adminId,
                                        'gift_item_name': name,
                                        'gift_item_description': desc,
                                        'price': price,
                                        'status': status,
                                      });
                                } else {
                                  success = await ref
                                      .read(giftProvider.notifier)
                                      .updateGiftItem(gift.giftId, {
                                        'gift_item_name': name,
                                        'gift_item_description': desc,
                                        'price': price,
                                        'status': status,
                                      });
                                }
                                if (success && mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        gift == null
                                            ? 'Gift added successfully'
                                            : 'Gift updated successfully',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                            )
                          : Text(
                              gift == null ? 'Add to Inventory' : 'Update Gift',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    );
                  },
                ),
              ),
              AppGaps.largeV,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(giftProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Gift Inventory',
        subtitle: 'Manage available gifts and stock',
        showBackButton: true,
        onMenuTap: () => context.pop(),
        actions: [
          PremiumAppbarAction(icon: Iconsax.add, onTap: () => _showGiftModal()),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppGaps.screenPadding),
            child: state.inventory.isEmpty && !state.isLoading
                ? const Center(
                    child: Text(
                      'Inventory is empty.',
                      style: TextStyle(color: AppColors.darkGrey),
                    ),
                  )
                : ListView.builder(
                    itemCount: state.inventory.length,
                    itemBuilder: (context, index) {
                      return GiftCard(
                        item: state.inventory[index],
                        onEdit: () =>
                            _showGiftModal(gift: state.inventory[index]),
                      );
                    },
                  ),
          ),
          if (state.isLoading) const Center(child: CircularProgressIndicator()),
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
