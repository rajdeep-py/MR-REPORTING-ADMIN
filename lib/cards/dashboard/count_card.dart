import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/dashboard.dart';

class CountCard extends StatelessWidget {
  final DashboardData data;
  const CountCard({super.key, required this.data});

  Widget _buildStatItem(String title, int count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withAlpha(150)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.black, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: [
        _buildStatItem('Total\nEmployees', data.totalEmployees, Iconsax.profile_2user),
        _buildStatItem('Doctor\nConnections', data.totalDoctors, Iconsax.health),
        _buildStatItem('Chemist\nShops', data.totalChemistShops, Iconsax.shop),
        _buildStatItem('Stockist\nConnections', data.totalStockists, Iconsax.box),
        _buildStatItem('Visual\nAds', data.totalVisualAds, Iconsax.monitor),
        _buildStatItem('Pending\nGifts', data.pendingGiftRequests, Iconsax.gift),
        _buildStatItem('Pending\nDCR', data.pendingDcr, Iconsax.document_text),
        _buildStatItem('Completed\nDCR', data.completedDcr, Iconsax.tick_circle),
        _buildStatItem('Pending\nChemist Rep', data.pendingChemistReporting, Iconsax.receipt_search),
        _buildStatItem('Completed\nChemist Rep', data.completedChemistReporting, Iconsax.receipt_item),
        _buildStatItem('Pending\nOrders', data.pendingOrders, Iconsax.shopping_cart),
        _buildStatItem('Approved\nOrders', data.completedOrders, Iconsax.bag_tick),
        _buildStatItem('Total\nTeams', data.totalTeams, Iconsax.people),
        _buildStatItem('Pending\nExpense', data.pendingExpense, Iconsax.wallet_money),
        _buildStatItem('Approved\nExpense', data.completedExpense, Iconsax.money_tick),
      ],
    );
  }
}
