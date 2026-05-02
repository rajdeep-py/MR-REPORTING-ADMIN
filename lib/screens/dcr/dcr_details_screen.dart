import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/dcr_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/visual_ads_provider.dart';
import '../../models/dcr.dart';
import '../../models/employee.dart';

class DcrDetailsScreen extends ConsumerWidget {
  final String id;
  const DcrDetailsScreen({super.key, required this.id});

  Color _getStatusColor(String status) {
    switch (status) {
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

  Widget _buildDcrInfoBlock(Dcr dcr) {
    final statusColor = _getStatusColor(dcr.status);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dcr.id, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withAlpha(50)),
                ),
                child: Text(
                  dcr.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          AppGaps.largeV,
          Row(
            children: [
              const Icon(Iconsax.calendar_1, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 8),
              Text(DateFormat('MMMM dd, yyyy').format(dcr.date), style: const TextStyle(color: AppColors.darkGrey, fontSize: 14)),
              const SizedBox(width: 24),
              const Icon(Iconsax.clock, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 8),
              Text(dcr.time, style: const TextStyle(color: AppColors.darkGrey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfoBlock(Dcr dcr) {
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
            children: [
              const Icon(Iconsax.health, color: AppColors.black, size: 20),
              AppGaps.mediumH,
              const Text('Doctor Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          AppGaps.largeV,
          Text(dcr.doctorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 4),
          Text(dcr.doctorSpecialization, style: const TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w600, fontSize: 14)),
          AppGaps.largeV,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Iconsax.location, size: 14, color: AppColors.darkGrey),
              const SizedBox(width: 8),
              Expanded(child: Text(dcr.placeOfAppointment, style: const TextStyle(color: AppColors.darkGrey, fontSize: 14, height: 1.5))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Iconsax.call, size: 14, color: AppColors.darkGrey),
              const SizedBox(width: 8),
              Text(dcr.doctorPhoneNo, style: const TextStyle(color: AppColors.darkGrey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInfoBlock(Employee employee) {
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
            children: [
              const Icon(Iconsax.user, color: AppColors.black, size: 20),
              AppGaps.mediumH,
              const Text('Medical Representative', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          AppGaps.largeV,
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: employee.profilePhotoPath != null ? NetworkImage(employee.profilePhotoPath!) : null,
                backgroundColor: AppColors.surface,
                child: employee.profilePhotoPath == null ? const Icon(Iconsax.user, color: AppColors.black) : null,
              ),
              AppGaps.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Iconsax.location, size: 12, color: AppColors.darkGrey),
                        const SizedBox(width: 4),
                        Text(employee.headquarter, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                        const SizedBox(width: 12),
                        const Icon(Iconsax.call, size: 12, color: AppColors.darkGrey),
                        const SizedBox(width: 4),
                        Text(employee.phoneNo, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
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

  Widget _buildVisualAdsBlock(WidgetRef ref, Dcr dcr) {
    final visualAdsState = ref.watch(visualAdsProvider);
    final presentedAds = visualAdsState.ads.where((ad) => dcr.presentedVisualAdIds.contains(ad.id)).toList();

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
            children: [
              const Icon(Iconsax.monitor, color: AppColors.black, size: 20),
              AppGaps.mediumH,
              const Text('Visual Ads Presented', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          AppGaps.largeV,
          if (presentedAds.isEmpty)
            const Text('No visual ads were presented during this visit.', style: TextStyle(color: AppColors.darkGrey))
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: presentedAds.map((ad) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: ad.imagePath.startsWith('http')
                              ? NetworkImage(ad.imagePath) as ImageProvider
                              : FileImage(File(ad.imagePath)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(ad.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 8),
                  ],
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dcrProvider);
    final dcrMatches = state.dcrs.where((d) => d.id == id).toList();
    
    if (dcrMatches.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PremiumAppBar(title: 'DCR Not Found', showBackButton: true, onMenuTap: () => context.pop()),
        body: const Center(child: Text('The Daily Call Report could not be found.')),
      );
    }
    
    final dcr = dcrMatches.first;

    final employees = ref.watch(employeeProvider);
    final employeeMatches = employees.employees.where((e) => e.id == dcr.employeeId).toList();
    final employee = employeeMatches.isNotEmpty ? employeeMatches.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: dcr.id,
        subtitle: 'Daily Call Report Details',
        showBackButton: true,
        onMenuTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDcrInfoBlock(dcr),
            _buildDoctorInfoBlock(dcr),
            if (employee != null) _buildEmployeeInfoBlock(employee),
            _buildVisualAdsBlock(ref, dcr),
          ],
        ),
      ),
    );
  }
}
