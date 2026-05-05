import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/privacy_policy.dart';
import '../services/privacy_policy/privacy_policy_services.dart';

class PrivacyPolicyNotifier extends StateNotifier<List<PrivacyPolicy>> {
  final PrivacyPolicyServices _services = PrivacyPolicyServices();

  PrivacyPolicyNotifier() : super([]) {
    fetchPolicies();
  }

  Future<void> fetchPolicies() async {
    try {
      final policies = await _services.getAllPrivacyPolicies();
      state = policies;
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print("Error fetching policies: $e");
      }
    }
  }
}
