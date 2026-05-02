import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/chemist_shop_provider.dart';
import '../../cards/chemist_shop/chemist_shop_header_card.dart';
import '../../cards/chemist_shop/chemist_shop_description_card.dart';
import '../../cards/chemist_shop/chemist_shop_products_interested_card.dart';
import '../../cards/chemist_shop/chemist_shop_contact_card.dart';

class ChemistShopDetailScreen extends ConsumerWidget {
  final String id;
  const ChemistShopDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chemistShopProvider);
    final shopMatches = state.shops.where((s) => s.id == id).toList();
    
    if (shopMatches.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PremiumAppBar(title: 'Shop Not Found', showBackButton: true, onMenuTap: () => context.pop()),
        body: const Center(child: Text('The chemist shop could not be found.')),
      );
    }
    
    final shop = shopMatches.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: shop.name,
        subtitle: 'Chemist Shop Details',
        showBackButton: true,
        onMenuTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChemistShopHeaderCard(shop: shop),
            ChemistShopDescriptionCard(shop: shop),
            ChemistShopProductsInterestedCard(shop: shop),
            ChemistShopContactCard(shop: shop),
          ],
        ),
      ),
    );
  }
}
