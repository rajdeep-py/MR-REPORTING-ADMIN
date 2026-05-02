import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/stockist_provider.dart';
import '../../cards/stockist/stockist_header_card.dart';
import '../../cards/stockist/stockist_description_card.dart';
import '../../cards/stockist/stockist_products_card.dart';
import '../../cards/stockist/stockist_order_delivery_info_card.dart';
import '../../cards/stockist/stockist_contact_card.dart';

class StockistDetailScreen extends ConsumerWidget {
  final String id;
  const StockistDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockistProvider);
    final stockistMatches = state.stockists.where((s) => s.id == id).toList();
    
    if (stockistMatches.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PremiumAppBar(title: 'Stockist Not Found', showBackButton: true, onMenuTap: () => context.pop()),
        body: const Center(child: Text('The stockist could not be found.')),
      );
    }
    
    final stockist = stockistMatches.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: stockist.name,
        subtitle: 'Stockist Details',
        showBackButton: true,
        onMenuTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StockistHeaderCard(stockist: stockist),
            StockistDescriptionCard(stockist: stockist),
            StockistProductsCard(stockist: stockist),
            StockistOrderDeliveryInfoCard(stockist: stockist),
            StockistContactCard(stockist: stockist),
          ],
        ),
      ),
    );
  }
}
