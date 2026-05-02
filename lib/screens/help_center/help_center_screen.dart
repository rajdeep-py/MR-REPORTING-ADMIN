import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/help_center/phone_card.dart';
import '../../cards/help_center/email_card.dart';
import '../../cards/help_center/visit_us_card.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Help Center',
        subtitle: 'Get support and find answers to your questions',
      ),
      drawer: SideNavBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            PhoneCard(),
            EmailCard(),
            VisitUsCard(),
          ],
        ),
      ),
    );
  }
}
