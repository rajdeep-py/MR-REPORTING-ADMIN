import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/terms_conditions_notifier.dart';
import '../models/terms_conditions.dart';

final termsConditionsProvider =
    StateNotifierProvider<TermsConditionsNotifier, List<TermsCondition>>((ref) {
      return TermsConditionsNotifier();
    });
