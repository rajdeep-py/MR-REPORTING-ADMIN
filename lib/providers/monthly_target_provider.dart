import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/monthly_target_notifier.dart';

final monthlyTargetProvider =
    StateNotifierProvider<MonthlyTargetNotifier, MonthlyTargetState>((ref) {
      return MonthlyTargetNotifier();
    });
