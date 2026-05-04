import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/stockist_notifier.dart';

final stockistProvider = StateNotifierProvider<StockistNotifier, StockistState>(
  (ref) {
    return StockistNotifier();
  },
);
