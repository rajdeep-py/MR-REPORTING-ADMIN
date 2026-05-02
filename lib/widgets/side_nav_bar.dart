import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme.dart';
import '../routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SideNavBar extends ConsumerWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Iconsax.category, color: AppColors.black),
                  ),
                  AppGaps.mediumH,
                  Text(
                    'MR Admin',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.lightGrey, height: 1),
            ListTile(
              leading: const Icon(Iconsax.user, color: AppColors.darkGrey),
              title: Text('Profile', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context); // close drawer
                context.go(AppRouter.profile);
              },
            ),
            const Spacer(),
            const Divider(color: AppColors.lightGrey, height: 1),
            ListTile(
              leading: const Icon(Iconsax.logout, color: AppColors.error),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.error),
              ),
              onTap: () {
                ref.read(authProvider.notifier).logout();
                Navigator.pop(context);
                context.go(AppRouter.login);
              },
            ),
            AppGaps.largeV,
          ],
        ),
      ),
    );
  }
}
