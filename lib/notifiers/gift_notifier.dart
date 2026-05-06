import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/gift.dart';
import '../services/gift/gift_inventory_services.dart';

class GiftState {
  final List<GiftItem> inventory;
  final List<GiftRequest> requests;
  final String filterStatus;
  final DateTimeRange? dateRange;
  final bool isLoading;
  final String? errorMessage;

  GiftState({
    this.inventory = const [],
    this.requests = const [],
    this.filterStatus = 'All',
    this.dateRange,
    this.isLoading = false,
    this.errorMessage,
  });

  GiftState copyWith({
    List<GiftItem>? inventory,
    List<GiftRequest>? requests,
    String? filterStatus,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GiftState(
      inventory: inventory ?? this.inventory,
      requests: requests ?? this.requests,
      filterStatus: filterStatus ?? this.filterStatus,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GiftNotifier extends StateNotifier<GiftState> {
  final GiftInventoryServices _services = GiftInventoryServices();

  GiftNotifier() : super(GiftState());

  Future<void> fetchGifts(String adminId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final gifts = await _services.getGiftsByAdmin(adminId);
      state = state.copyWith(inventory: gifts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> addGiftItem(Map<String, dynamic> giftData) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final newGift = await _services.createGift(giftData);
      state = state.copyWith(
        inventory: [newGift, ...state.inventory],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateGiftItem(String giftId, Map<String, dynamic> giftData) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updatedGift = await _services.updateGift(giftId, giftData);
      final updatedList = state.inventory.map((g) {
        return g.giftId == giftId ? updatedGift : g;
      }).toList();
      state = state.copyWith(inventory: updatedList, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteGiftItem(String giftId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final success = await _services.deleteGift(giftId);
      if (success) {
        state = state.copyWith(
          inventory: state.inventory.where((g) => g.giftId != giftId).toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Delete failed');
      }
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range, clearDateRange: range == null);
  }

  void updateRequestStatus(String requestId, String newStatus) {
    final updated = state.requests.map((r) {
      if (r.id == requestId) return r.copyWith(status: newStatus);
      return r;
    }).toList();
    state = state.copyWith(requests: updated);
  }
}
