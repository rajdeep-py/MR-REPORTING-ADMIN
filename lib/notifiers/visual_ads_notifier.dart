import 'dart:typed_data';
import 'package:flutter_riverpod/legacy.dart';
import '../models/visual_ads.dart';
import '../services/visual_ads/visual_ads_services.dart';

class VisualAdsState {
  final List<VisualAd> ads;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String filterStatus;

  VisualAdsState({
    this.ads = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.filterStatus = 'All',
  });

  VisualAdsState copyWith({
    List<VisualAd>? ads,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? filterStatus,
  }) {
    return VisualAdsState(
      ads: ads ?? this.ads,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}

class VisualAdsNotifier extends StateNotifier<VisualAdsState> {
  final VisualAdsServices _services = VisualAdsServices();

  VisualAdsNotifier() : super(VisualAdsState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }

  Future<void> fetchAds(String adminId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ads = await _services.getAllVisualAds(adminId);
      state = state.copyWith(ads: ads, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<bool> addAd({
    required String adminId,
    required String productName,
    String? productQuantity,
    String? productDescription,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newAd = await _services.createVisualAd(
        adminId: adminId,
        productName: productName,
        productQuantity: productQuantity,
        productDescription: productDescription,
        imageBytes: imageBytes,
        imageName: imageName,
      );
      if (newAd != null) {
        state = state.copyWith(
          ads: [...state.ads, newAd],
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateAd({
    required String visualAdId,
    String? productName,
    String? productQuantity,
    String? productDescription,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedAd = await _services.updateVisualAd(
        visualAdId: visualAdId,
        productName: productName,
        productQuantity: productQuantity,
        productDescription: productDescription,
        status: status,
        imageBytes: imageBytes,
        imageName: imageName,
      );
      if (updatedAd != null) {
        state = state.copyWith(
          ads: state.ads.map((ad) => ad.visualAdId == visualAdId ? updatedAd : ad).toList(),
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteAd(String visualAdId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _services.deleteVisualAd(visualAdId);
      if (success) {
        state = state.copyWith(
          ads: state.ads.where((ad) => ad.visualAdId != visualAdId).toList(),
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }
}
