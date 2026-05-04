import 'package:flutter_riverpod/legacy.dart';
import '../models/chemist_shop.dart';

class ChemistShopState {
  final List<ChemistShop> shops;
  final String searchEmployeeQuery;
  final String filterLocation;

  ChemistShopState({
    this.shops = const [],
    this.searchEmployeeQuery = '',
    this.filterLocation = 'All',
  });

  ChemistShopState copyWith({
    List<ChemistShop>? shops,
    String? searchEmployeeQuery,
    String? filterLocation,
  }) {
    return ChemistShopState(
      shops: shops ?? this.shops,
      searchEmployeeQuery: searchEmployeeQuery ?? this.searchEmployeeQuery,
      filterLocation: filterLocation ?? this.filterLocation,
    );
  }
}

class ChemistShopNotifier extends StateNotifier<ChemistShopState> {
  ChemistShopNotifier() : super(ChemistShopState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      shops: [
        const ChemistShop(
          id: '1',
          name: 'HealthPlus Pharmacy',
          photoPath:
              'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=400&q=80',
          address: '101 Wellness Blvd, Sector 4',
          location: 'Mumbai',
          phoneNo: '+91 98765 43210',
          email: 'contact@healthplus.in',
          description:
              'HealthPlus is a major retail chain of pharmacies offering a wide range of generic and branded medicines, healthcare products, and wellness supplements.',
          employeeId: 'EMP001',
          interestedProductIds: ['1'],
        ),
        const ChemistShop(
          id: '2',
          name: 'CareWell Meds',
          photoPath:
              'https://images.unsplash.com/photo-1576602976047-174e57a47881?w=400&q=80',
          address: '42 Health St, Main Market',
          location: 'Delhi',
          phoneNo: '+91 87654 32109',
          email: 'info@carewell.in',
          description:
              'A neighborhood pharmacy serving the local community for over 15 years, specializing in pediatric and geriatric medicines.',
          employeeId: 'EMP002',
          interestedProductIds: ['1', '2'],
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
