import 'package:flutter_riverpod/legacy.dart';
import '../models/stockist.dart';

class StockistState {
  final List<Stockist> stockists;
  final String searchEmployeeQuery;
  final String filterLocation;

  StockistState({
    this.stockists = const [],
    this.searchEmployeeQuery = '',
    this.filterLocation = 'All',
  });

  StockistState copyWith({
    List<Stockist>? stockists,
    String? searchEmployeeQuery,
    String? filterLocation,
  }) {
    return StockistState(
      stockists: stockists ?? this.stockists,
      searchEmployeeQuery: searchEmployeeQuery ?? this.searchEmployeeQuery,
      filterLocation: filterLocation ?? this.filterLocation,
    );
  }
}

class StockistNotifier extends StateNotifier<StockistState> {
  StockistNotifier() : super(StockistState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      stockists: [
        const Stockist(
          id: '1',
          name: 'MediCorp Distributors',
          photoPath:
              'https://images.unsplash.com/photo-1563213126-a4273aed2016?w=400&q=80',
          address: '200 Industrial Estate, Block C',
          location: 'Mumbai',
          phoneNo: '+91 99887 76655',
          email: 'supply@medicorp.in',
          description:
              'MediCorp is one of the largest pharmaceutical distributors in the region, serving over 500 retail pharmacies and hospitals with a diverse portfolio of generic and specialized drugs.',
          expectedDeliveryTime: '24-48 Hours',
          minimumOrderValue: 50000.0,
          employeeId: 'EMP001',
          interestedProductIds: ['1', '2'],
        ),
        const Stockist(
          id: '2',
          name: 'Prime Health Supply',
          photoPath:
              'https://images.unsplash.com/photo-1580982327559-c1202864eb05?w=400&q=80',
          address: '50 Logistics Park, Ring Road',
          location: 'Delhi',
          phoneNo: '+91 88776 65544',
          email: 'orders@primehealth.in',
          description:
              'Prime Health specializes in cold chain distribution and bulk supply of essential medicines.',
          expectedDeliveryTime: 'Same Day',
          minimumOrderValue: 25000.0,
          employeeId: 'EMP002',
          interestedProductIds: ['1'],
        ),
      ],
    );
  }

  void setSearchEmployeeQuery(String query) {
    state = state.copyWith(searchEmployeeQuery: query);
  }

  void setFilterLocation(String location) {
    state = state.copyWith(filterLocation: location);
  }
}
