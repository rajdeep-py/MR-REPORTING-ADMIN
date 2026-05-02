import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/about_us/company_header_card.dart';
import '../../cards/about_us/company_description_card.dart';
import '../../cards/about_us/director_message_card.dart';
import '../../cards/about_us/company_contact_card.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'About Us',
        subtitle: 'Learn more about our company and mission',
      ),
      drawer: SideNavBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            CompanyHeaderCard(),
            AppGaps.largeV,
            CompanyDescriptionCard(),
            AppGaps.largeV,
            DirectorMessageCard(),
            AppGaps.largeV,
            CompanyContactCard(),
            AppGaps.extraLargeV,
          ],
        ),
      ),
    );
  }
}
