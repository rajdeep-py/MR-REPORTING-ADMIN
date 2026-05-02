import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/attendance/attendance_filter_search_card.dart';
import '../../cards/attendance/attendance_calendar_card.dart';
import '../../cards/attendance/attendance_details_card.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Attendance Record',
        subtitle: 'Track and manage employee attendance',
      ),
      drawer: const SideNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const AttendanceFilterSearchCard(),
            AppGaps.largeV,
            if (isDesktop)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: AttendanceCalendarCard(),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: AttendanceDetailsCard(),
                  ),
                ],
              )
            else
              const Column(
                children: [
                  AttendanceCalendarCard(),
                  SizedBox(height: 24),
                  AttendanceDetailsCard(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
