import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/chemist_shop_reporting_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/visual_ads_provider.dart';
import '../../models/chemist_shop_reporting.dart';
import '../../models/employee.dart';

class ChemistShopReportingDetailsScreen extends ConsumerWidget {
  final String id;
  const ChemistShopReportingDetailsScreen({super.key, required this.id});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.darkGrey;
    }
  }

  Widget _buildHeroBlock(ChemistShopReporting report, BuildContext context) {
    final statusColor = _getStatusColor(report.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.black, Color(0xFF2A2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.receipt_2,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      report.id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  report.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          AppGaps.extraLargeV,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(
                        color: AppColors.midGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(report.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withAlpha(50),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(
                        color: AppColors.midGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    Color iconColor = AppColors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopInfoBlock(ChemistShopReporting report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chemist Shop Details',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: -0.5,
            ),
          ),
          AppGaps.largeV,
          _buildInfoRow(
            Iconsax.shop,
            'Shop Name',
            report.chemistShopName,
            iconColor: AppColors.black,
          ),
          _buildInfoRow(
            Iconsax.location,
            'Appointment Location',
            report.placeOfAppointment,
          ),
          _buildInfoRow(
            Iconsax.call,
            'Contact Number',
            report.chemistShopPhoneNo,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInfoBlock(Employee employee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assigned Representative',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: -0.5,
            ),
          ),
          AppGaps.largeV,
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  image: employee.profilePhotoPath != null
                      ? DecorationImage(
                          image: NetworkImage(employee.profilePhotoPath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: employee.profilePhotoPath == null
                    ? const Icon(Iconsax.user, color: AppColors.black, size: 24)
                    : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.location,
                                size: 12,
                                color: AppColors.darkGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                employee.headquarter,
                                style: const TextStyle(
                                  color: AppColors.darkGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.call,
                                size: 12,
                                color: AppColors.darkGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                employee.phoneNo,
                                style: const TextStyle(
                                  color: AppColors.darkGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisualAdsBlock(WidgetRef ref, ChemistShopReporting report) {
    final visualAdsState = ref.watch(visualAdsProvider);
    final presentedAds = visualAdsState.ads
        .where((ad) => report.presentedVisualAdIds.contains(ad.visualAdId))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Visual Ads Presented',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${presentedAds.length} Items',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          AppGaps.largeV,
          if (presentedAds.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.lightGrey,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(
                      Iconsax.gallery_slash,
                      color: AppColors.midGrey,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No visual ads presented',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: presentedAds.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ad = presentedAds[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          //image: DecorationImage(
                          // image: ad.productImage.startsWith('http')
                          //     ? NetworkImage(ad.productImage) as ImageProvider
                          //     : FileImage(File(ad.productImage)),
                          // fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Visual Ad • ID: ${ad.visualAdId}',
                              style: const TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Iconsax.arrow_right_3,
                        color: AppColors.darkGrey,
                        size: 16,
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chemistShopReportingProvider);
    final reportMatches = state.reports.where((r) => r.id == id).toList();

    if (reportMatches.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PremiumAppBar(
          title: 'Report Not Found',
          showBackButton: true,
          onMenuTap: () => context.pop(),
        ),
        body: const Center(
          child: Text('The Chemist Shop Report could not be found.'),
        ),
      );
    }

    final report = reportMatches.first;

    final employees = ref.watch(employeeProvider);
    final employeeMatches = employees.employees
        .where((e) => e.id == report.employeeId)
        .toList();
    final employee = employeeMatches.isNotEmpty ? employeeMatches.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Report Details',
        subtitle: 'Chemist Visit Information',
        showBackButton: true,
        onMenuTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroBlock(report, context),
            _buildShopInfoBlock(report),
            if (employee != null) _buildEmployeeInfoBlock(employee),
            _buildVisualAdsBlock(ref, report),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
