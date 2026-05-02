import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/privacy_policy_provider.dart';
import '../../cards/privacy_policy/privacy_policy_card.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policies = ref.watch(privacyPolicyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Privacy Policy',
        subtitle: 'Learn how we collect and use your data',
      ),
      drawer: const SideNavBar(),
      body: policies.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
          : ListView.builder(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              itemCount: policies.length,
              itemBuilder: (context, index) {
                return PrivacyPolicyCard(policy: policies[index]);
              },
            ),
    );
  }
}
