import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/order_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/visual_ads_provider.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/chemist_shop_provider.dart';
import '../../providers/stockist_provider.dart';
import '../../models/order.dart';
import '../../models/employee.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String id;
  const OrderDetailsScreen({super.key, required this.id});

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

  Widget _buildHeroBlock(Order order, BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(order.status);

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
                    const Icon(Iconsax.box_1, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      order.id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _showStatusChangeDialog(context, ref, order);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        order.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Iconsax.arrow_down_1,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
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
                      'Ordered On',
                      style: TextStyle(
                        color: AppColors.midGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(order.orderedOn),
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
                      'Delivery Date',
                      style: TextStyle(
                        color: AppColors.midGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(order.deliveryDate),
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

  void _showStatusChangeDialog(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Order Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              AppGaps.largeV,
              _buildStatusOption(
                context,
                ref,
                order.id,
                'pending',
                'Pending',
                Colors.orange,
              ),
              _buildStatusOption(
                context,
                ref,
                order.id,
                'completed',
                'Completed',
                Colors.green,
              ),
              _buildStatusOption(
                context,
                ref,
                order.id,
                'cancelled',
                'Cancelled',
                Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    WidgetRef ref,
    String orderId,
    String statusValue,
    String statusLabel,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        ref
            .read(orderProvider.notifier)
            .updateOrderStatus(orderId, statusValue);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              statusLabel,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
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

  Widget _buildOrderedByEntityBlock(WidgetRef ref, Order order) {
    Widget? content;

    if (order.doctorId != null) {
      final doctors = ref.watch(doctorProvider);
      final doctorMatch = doctors.doctors
          .where((d) => d.id == order.doctorId)
          .toList();
      if (doctorMatch.isNotEmpty) {
        content = _buildInfoRow(
          Iconsax.health,
          'Doctor',
          doctorMatch.first.name,
          iconColor: AppColors.black,
        );
      }
    } else if (order.chemistShopId != null) {
      final chemists = ref.watch(chemistShopProvider);
      final chemistMatch = chemists.shops
          .where((c) => c.id == order.chemistShopId)
          .toList();
      if (chemistMatch.isNotEmpty) {
        content = _buildInfoRow(
          Iconsax.shop,
          'Chemist Shop',
          chemistMatch.first.name,
          iconColor: AppColors.black,
        );
      }
    } else if (order.stockistId != null) {
      final stockists = ref.watch(stockistProvider);
      final stockistMatch = stockists.stockists
          .where((s) => s.id == order.stockistId)
          .toList();
      if (stockistMatch.isNotEmpty) {
        content = _buildInfoRow(
          Iconsax.box,
          'Stockist',
          stockistMatch.first.name,
          iconColor: AppColors.black,
        );
      }
    }

    if (content == null) return const SizedBox.shrink();

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
            'Ordered For',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: -0.5,
            ),
          ),
          AppGaps.largeV,
          content,
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
            'Representative (Ordered By)',
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

  Widget _buildProductsBlock(WidgetRef ref, Order order) {
    final visualAdsState = ref.watch(visualAdsProvider);

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
                'Products Needed',
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
                  'Total ₹${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          AppGaps.largeV,
          if (order.items.isEmpty)
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
                      Iconsax.box_remove,
                      color: AppColors.midGrey,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No products listed',
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
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = order.items[index];
                final adMatches = visualAdsState.ads
                    .where((ad) => ad.visualAdId == item.productId)
                    .toList();
                final ad = adMatches.isNotEmpty ? adMatches.first : null;

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
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          //image: ad != null
                          // ? DecorationImage(
                          //     image: ad.productImage.startsWith('http')
                          //         ? NetworkImage(ad.productImage)
                          //               as ImageProvider
                          //         : FileImage(File(ad.productImage)),
                          //     fit: BoxFit.cover,
                          //   )
                          //: null,
                        ),
                        child: ad == null
                            ? const Icon(Iconsax.box, color: AppColors.midGrey)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad?.productName ?? 'Unknown Product',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${item.productId}',
                              style: const TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                        child: Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
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
    final state = ref.watch(orderProvider);
    final orderMatches = state.orders.where((o) => o.id == id).toList();

    if (orderMatches.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PremiumAppBar(
          title: 'Order Not Found',
          showBackButton: true,
          onMenuTap: () => context.pop(),
        ),
        body: const Center(child: Text('The Order could not be found.')),
      );
    }

    final order = orderMatches.first;

    final employees = ref.watch(employeeProvider);
    final employeeMatches = employees.employees
        .where((e) => e.id == order.employeeId)
        .toList();
    final employee = employeeMatches.isNotEmpty ? employeeMatches.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Order Details',
        subtitle: 'Product fulfillment & tracking',
        showBackButton: true,
        onMenuTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroBlock(order, context, ref),
            _buildOrderedByEntityBlock(ref, order),
            if (employee != null) _buildEmployeeInfoBlock(employee),
            _buildProductsBlock(ref, order),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
