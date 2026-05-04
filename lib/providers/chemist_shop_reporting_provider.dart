import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/chemist_shop_reporting_notifier.dart';

final chemistShopReportingProvider =
    StateNotifierProvider<
      ChemistShopReportingNotifier,
      ChemistShopReportingState
    >((ref) {
      return ChemistShopReportingNotifier();
    });
