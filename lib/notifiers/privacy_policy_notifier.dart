import 'package:flutter_riverpod/legacy.dart';
import '../models/privacy_policy.dart';

class PrivacyPolicyNotifier extends StateNotifier<List<PrivacyPolicy>> {
  PrivacyPolicyNotifier() : super([]) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = const [
      PrivacyPolicy(
        id: '1',
        header: 'Information We Collect',
        description:
            'We may collect personal information such as your name, email address, phone number, and location data when you use our application. This helps us provide better services and ensure account security.',
      ),
      PrivacyPolicy(
        id: '2',
        header: 'How We Use Your Information',
        description:
            'Your information is used to personalize your experience, improve our platform, and communicate with you regarding updates, offers, and support. We do not sell your personal data to third parties.',
      ),
      PrivacyPolicy(
        id: '3',
        header: 'Data Security',
        description:
            'We implement industry-standard security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no internet transmission is entirely secure.',
      ),
      PrivacyPolicy(
        id: '4',
        header: 'Changes to This Policy',
        description:
            'We may update our Privacy Policy occasionally. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
      ),
    ];
  }
}
