import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../widgets/footer.dart';
import '../../cards/monthly_target/monthly_target_filter_search_card.dart';
import '../../cards/monthly_target/monthly_target_card.dart';
import '../../cards/monthly_target/monthly_target_details_card.dart';

class MonthlyTargetScreen extends ConsumerWidget {
  const MonthlyTargetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Monthly Targets',
        subtitle: 'Manage and track employee monthly targets',
        actions: [
          PremiumAppbarAction(
            icon: Iconsax.document_download,
            onTap: () {
              AppTheme.showPremiumSnackBar(
                context: context,
                message: 'Downloading report...',
                isError: false,
              );
            },
          ),
        ],
      ),
      drawer: const SideNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MonthlyTargetFilterSearchCard(),
            AppGaps.largeV,
            const MonthlyTargetCard(),
            AppGaps.largeV,
            const MonthlyTargetDetailsCard(),
            AppGaps.extraLargeV,
            const Footer(),
          ],
        ),
      ),
    );
  }
}
