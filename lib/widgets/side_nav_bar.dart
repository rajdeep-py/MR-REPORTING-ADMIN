import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../routes/app_router.dart';
import '../providers/auth_provider.dart';

class NavGroup {
  final String? title;
  final List<NavItem> items;

  const NavGroup({this.title, required this.items});
}

class NavItem {
  final String title;
  final IconData icon;
  final String route;

  const NavItem(this.title, this.icon, this.route);
}

class SideNavBar extends ConsumerWidget {
  const SideNavBar({super.key});

  static const List<NavGroup> _navGroups = [
    NavGroup(
      items: [
        NavItem('Dashboard & Analytics', Iconsax.category, AppRouter.dashboard),
        NavItem('Profile', Iconsax.user, AppRouter.profile),
        NavItem('Notifications', Iconsax.notification, AppRouter.notifications),
      ],
    ),
    NavGroup(
      title: 'Management',
      items: [
        NavItem(
          'Employee Management',
          Iconsax.people,
          AppRouter.employeeManagement,
        ),
        NavItem(
          'Team Management',
          Iconsax.profile_2user,
          AppRouter.teamManagement,
        ),
        NavItem(
          'Attendance Record',
          Iconsax.calendar_tick,
          AppRouter.attendance,
        ),
        NavItem('Monthly Targets', Iconsax.lock, AppRouter.monthlyTarget),
      ],
    ),
    NavGroup(
      title: 'Operations',
      items: [
        NavItem('Routine Management', Iconsax.task_square, AppRouter.routine),
        NavItem('Expense Tracker', Iconsax.wallet_money, AppRouter.expense),
        NavItem('Gifts Management', Iconsax.gift, AppRouter.gifts),
        NavItem('DCR Management', Iconsax.document_text, AppRouter.dcr),
        NavItem(
          'Chemist Shop Reporting',
          Iconsax.shop,
          AppRouter.chemistReporting,
        ),
      ],
    ),
    NavGroup(
      title: 'Connections',
      items: [
        NavItem(
          'Doctor Connections',
          Iconsax.health,
          AppRouter.doctorConnections,
        ),
        NavItem(
          'Chemist Shop Connections',
          Iconsax.shop_add,
          AppRouter.chemistConnections,
        ),
        NavItem(
          'Stockist Connections',
          Iconsax.box,
          AppRouter.stockistConnections,
        ),
      ],
    ),
    NavGroup(
      title: 'Marketing & Comms',
      items: [
        NavItem('Visual Ads Management', Iconsax.monitor, AppRouter.visualAds),
        NavItem(
          'Announcement Management',
          Iconsax.speaker,
          AppRouter.announcements,
        ),
      ],
    ),
    NavGroup(
      title: 'Support & Legal',
      items: [
        NavItem('About Us', Iconsax.info_circle, AppRouter.aboutUs),
        NavItem('Help Center', Iconsax.support, AppRouter.helpCenter),
        NavItem('Give Feedback', Iconsax.messages, AppRouter.feedback),
        NavItem('Terms & Conditions', Iconsax.document_copy, AppRouter.terms),
        NavItem('Privacy & Policies', Iconsax.shield_tick, AppRouter.privacy),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine the current path for active state highlighting
    final currentPath = GoRouterState.of(context).uri.path;

    return Drawer(
      width: 460,
      backgroundColor: AppColors.white,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),
            const Divider(color: AppColors.lightGrey, height: 1),

            // Scrollable Menu Items & Logout
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ..._navGroups.map(
                      (group) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (group.title != null) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 16,
                                bottom: 8,
                              ),
                              child: Text(
                                group.title!.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                            ),
                          ],
                          ...group.items.map(
                            (item) => _buildNavItem(context, item, currentPath),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.lightGrey, height: 1),
                    const SizedBox(height: 16),

                    // Logout Button (Not stacked, scrolls with items)
                    _buildLogoutBtn(context, ref),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGrey, width: 1),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/logo/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Iconsax.image, color: AppColors.darkGrey),
            ),
          ),
          AppGaps.mediumH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MR Admin',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  'Reporting Portal',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item, String currentPath) {
    final isSelected = currentPath == item.route;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () {
          // Only navigate if it's not the current route
          if (!isSelected) {
            Navigator.pop(context); // Close drawer
            try {
              context.go(item.route);
            } catch (e) {
              AppTheme.showPremiumSnackBar(
                context: context,
                message: 'Module not implemented yet!',
                isError: true,
              );
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.black.withAlpha(15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: isSelected ? AppColors.black : AppColors.darkGrey,
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected ? AppColors.black : AppColors.black,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutBtn(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(authProvider.notifier).logout();
        Navigator.pop(context);
        context.go(AppRouter.login);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.error.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.logout, color: AppColors.error, size: 22),
            const SizedBox(width: 16),
            Text(
              'Log out',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
