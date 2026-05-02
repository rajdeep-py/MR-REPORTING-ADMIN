import 'package:flutter_riverpod/legacy.dart';
import '../models/visual_ads.dart';

class VisualAdsState {
  final List<VisualAd> ads;
  final String searchQuery;
  final String filterStatus; // 'All', 'Active', 'Inactive'

  VisualAdsState({
    this.ads = const [],
    this.searchQuery = '',
    this.filterStatus = 'All',
  });

  VisualAdsState copyWith({
    List<VisualAd>? ads,
    String? searchQuery,
    String? filterStatus,
  }) {
    return VisualAdsState(
      ads: ads ?? this.ads,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}

class VisualAdsNotifier extends StateNotifier<VisualAdsState> {
  VisualAdsNotifier() : super(VisualAdsState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(ads: [
      const VisualAd(
        id: '1',
        productName: 'Paracetamol 500mg',
        imagePath: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&q=80',
        isActive: true,
      ),
      const VisualAd(
        id: '2',
        productName: 'Vitamin C Complex',
        imagePath: 'https://images.unsplash.com/photo-1550572017-edb7993006a8?w=400&q=80',
        isActive: false,
      ),
    ]);
  }

  void addAd(String productName, String imagePath, bool isActive) {
    final newAd = VisualAd(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productName: productName,
      imagePath: imagePath,
      isActive: isActive,
    );
    state = state.copyWith(ads: [newAd, ...state.ads]);
  }

  void updateAd(String id, String productName, String imagePath, bool isActive) {
    final updatedAds = state.ads.map((ad) {
      if (ad.id == id) {
        return ad.copyWith(productName: productName, imagePath: imagePath, isActive: isActive);
      }
      return ad;
    }).toList();
    state = state.copyWith(ads: updatedAds);
  }

  void deleteAd(String id) {
    state = state.copyWith(ads: state.ads.where((ad) => ad.id != id).toList());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }
}
