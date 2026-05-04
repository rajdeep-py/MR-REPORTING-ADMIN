import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/chemist_shop_notifier.dart';

final chemistShopProvider =
    StateNotifierProvider<ChemistShopNotifier, ChemistShopState>((ref) {
      return ChemistShopNotifier();
    });
