import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/gift_provider.dart';
import '../../cards/gift/gift_filter_card.dart';
import '../../cards/gift/gift_request_card.dart';

class GiftScreen extends ConsumerWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(giftProvider);

    final filteredRequests = state.requests.where((req) {
      if (state.filterStatus != 'All' && req.status != state.filterStatus) {
        return false;
      }
      
      if (state.dateRange != null) {
        final rDate = DateTime(req.requestedOn.year, req.requestedOn.month, req.requestedOn.day);
        final startDate = DateTime(state.dateRange!.start.year, state.dateRange!.start.month, state.dateRange!.start.day);
        final endDate = DateTime(state.dateRange!.end.year, state.dateRange!.end.month, state.dateRange!.end.day);
        
        if (rDate.isBefore(startDate) || rDate.isAfter(endDate)) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Gifts Management',
        subtitle: 'Review & approve employee gift requests',
        actions: [
          PremiumAppbarAction(
            icon: Iconsax.box,
            onTap: () => context.push('/gift-inventory'),
          ),
        ],
      ),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const GiftFilterCard(),
            AppGaps.largeV,
            Expanded(
              child: filteredRequests.isEmpty
                  ? const Center(child: Text('No gift requests found.', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        return GiftRequestCard(request: filteredRequests[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
