import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/terms_conditions_provider.dart';
import '../../cards/terms_conditions/terms_conditions_card.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terms = ref.watch(termsConditionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Terms and Conditions',
        subtitle: 'Please read our terms carefully',
      ),
      drawer: const SideNavBar(),
      body: terms.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
          : ListView.builder(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              itemCount: terms.length,
              itemBuilder: (context, index) {
                return TermsConditionsCard(condition: terms[index]);
              },
            ),
    );
  }
}
