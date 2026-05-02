import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/stockist.dart';

class StockistOrderDeliveryInfoCard extends StatelessWidget {
  final Stockist stockist;
  const StockistOrderDeliveryInfoCard({super.key, required this.stockist});

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.black, size: 20),
          ),
          AppGaps.mediumH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w700, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          const Text('Order & Delivery Info', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          AppGaps.largeV,
          _buildInfoRow(Iconsax.truck_fast, 'Expected Delivery Time', stockist.expectedDeliveryTime),
          _buildInfoRow(Iconsax.receipt, 'Minimum Order Value', '₹${stockist.minimumOrderValue.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
