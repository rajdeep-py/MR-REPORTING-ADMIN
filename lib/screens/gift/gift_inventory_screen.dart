import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/gift_provider.dart';
import '../../models/gift.dart';
import '../../cards/gift/gift_card.dart';

class GiftInventoryScreen extends ConsumerStatefulWidget {
  const GiftInventoryScreen({super.key});

  @override
  ConsumerState<GiftInventoryScreen> createState() => _GiftInventoryScreenState();
}

class _GiftInventoryScreenState extends ConsumerState<GiftInventoryScreen> {
  void _showAddGiftModal() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final imageCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
              const Text('Add New Gift', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              AppGaps.largeV,
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Gift Name',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              AppGaps.mediumV,
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              AppGaps.mediumV,
              TextField(
                controller: imageCtrl,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              AppGaps.mediumV,
              TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Initial Stock',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              AppGaps.extraLargeV,
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final desc = descCtrl.text.trim();
                    final img = imageCtrl.text.trim().isEmpty ? 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400&q=80' : imageCtrl.text.trim();
                    final stock = int.tryParse(stockCtrl.text.trim()) ?? 0;

                    if (name.isNotEmpty) {
                      final newGift = GiftItem(
                        id: 'G-${Random().nextInt(9999) + 1000}',
                        name: name,
                        description: desc,
                        imageUrl: img,
                        stockCount: stock,
                      );
                      ref.read(giftProvider.notifier).addGiftItem(newGift);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add to Inventory', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 16)),
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
          PremiumAppbarAction(
            icon: Iconsax.add,
            onTap: _showAddGiftModal,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: state.inventory.isEmpty
            ? const Center(child: Text('Inventory is empty.', style: TextStyle(color: AppColors.darkGrey)))
            : ListView.builder(
                itemCount: state.inventory.length,
                itemBuilder: (context, index) {
                  return GiftCard(item: state.inventory[index]);
                },
              ),
      ),
    );
  }
}
