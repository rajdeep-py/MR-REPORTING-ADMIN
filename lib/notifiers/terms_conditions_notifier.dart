import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/terms_conditions.dart';
import '../services/terms_conditions/terms_conditions_services.dart';

class TermsConditionsNotifier extends StateNotifier<List<TermsCondition>> {
  final TermsConditionsServices _services = TermsConditionsServices();

  TermsConditionsNotifier() : super([]) {
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    try {
      final terms = await _services.getAllTermsConditions();
      state = terms;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching terms: $e");
      }
    }
  }
}
