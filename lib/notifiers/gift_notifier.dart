import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/gift.dart';

class GiftState {
  final List<GiftItem> inventory;
  final List<GiftRequest> requests;
  final String filterStatus;
  final DateTimeRange? dateRange;

  GiftState({
    this.inventory = const [],
    this.requests = const [],
    this.filterStatus = 'All',
    this.dateRange,
  });

  GiftState copyWith({
    List<GiftItem>? inventory,
    List<GiftRequest>? requests,
    String? filterStatus,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
  }) {
    return GiftState(
      inventory: inventory ?? this.inventory,
      requests: requests ?? this.requests,
      filterStatus: filterStatus ?? this.filterStatus,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    );
  }
}

class GiftNotifier extends StateNotifier<GiftState> {
  GiftNotifier() : super(GiftState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      inventory: [
        const GiftItem(
          id: 'G-101',
          name: 'Premium Pen Set',
          imageUrl: 'https://images.unsplash.com/photo-1585336261022-680e295ce3fe?w=400&q=80',
          description: 'High quality metal body ballpoint pen set.',
          stockCount: 50,
        ),
        const GiftItem(
          id: 'G-102',
          name: 'Desk Organizer',
          imageUrl: 'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?w=400&q=80',
          description: 'Wooden desk organizer with built-in clock.',
          stockCount: 15,
        ),
      ],
      requests: [
        GiftRequest(
          id: 'REQ-1001',
          requestedOn: DateTime.now().subtract(const Duration(days: 1)),
          employeeId: 'EMP001',
          doctorId: '1',
          occasion: 'Doctor\'s Day',
          status: 'pending',
          giftItemId: 'G-101',
        ),
        GiftRequest(
          id: 'REQ-1002',
          requestedOn: DateTime.now().subtract(const Duration(days: 3)),
          employeeId: 'EMP002',
          doctorId: '2',
          occasion: 'Clinic Anniversary',
          status: 'approved',
          giftItemId: 'G-102',
        ),
      ],
    );
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

  void addGiftItem(GiftItem item) {
    state = state.copyWith(inventory: [item, ...state.inventory]);
  }
}
