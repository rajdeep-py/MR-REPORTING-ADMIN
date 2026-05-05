import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/visual_ads_provider.dart';
import '../../providers/auth_provider.dart';
import '../../cards/visual_ads/visual_ads_search_bar.dart';
import '../../cards/visual_ads/visual_ads_card.dart';
import '../../cards/visual_ads/create_edit_visual_ads_card.dart';

class VisualAdsScreen extends ConsumerStatefulWidget {
  const VisualAdsScreen({super.key});

  @override
  ConsumerState<VisualAdsScreen> createState() => _VisualAdsScreenState();
}

class _VisualAdsScreenState extends ConsumerState<VisualAdsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authState = ref.read(authProvider);
      final adminId = authState.value?.adminId;
      if (adminId != null) {
        ref.read(visualAdsProvider.notifier).fetchAds(adminId);
      }
    });
  }

  void _showCreateVisualAd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateEditVisualAdsCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(visualAdsProvider);
    final authState = ref.watch(authProvider);
    final adminId = authState.value?.adminId;

    final filteredAds = state.ads.where((ad) {
      if (state.searchQuery.isNotEmpty &&
          !ad.productName.toLowerCase().contains(state.searchQuery.toLowerCase())) {
        return false;
      }
      if (state.filterStatus == 'Active' && ad.status != 'active') return false;
      if (state.filterStatus == 'Inactive' && ad.status != 'inactive') return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Visual Ads',
        subtitle: 'Manage and upload visual advertisements',
        actions: [
          ElevatedButton.icon(
            onPressed: adminId == null ? null : () => _showCreateVisualAd(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const SideNavBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          if (adminId != null) {
            await ref.read(visualAdsProvider.notifier).fetchAds(adminId);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppGaps.screenPadding),
          child: Column(
            children: [
              const VisualAdsSearchBar(),
              AppGaps.largeV,
              Expanded(
                child: state.isLoading && state.ads.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filteredAds.isEmpty
                        ? const Center(
                            child: Text(
                              'No visual ads found.',
                              style: TextStyle(color: AppColors.darkGrey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredAds.length,
                            itemBuilder: (context, index) {
                              return VisualAdsCard(ad: filteredAds[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
