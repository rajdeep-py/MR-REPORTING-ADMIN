import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/privacy_policy_notifier.dart';
import '../models/privacy_policy.dart';

final privacyPolicyProvider =
    StateNotifierProvider<PrivacyPolicyNotifier, List<PrivacyPolicy>>((ref) {
  return PrivacyPolicyNotifier();
});
