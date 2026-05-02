import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme.dart';

class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;
  final bool showBackButton;

  const PremiumAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
    this.onMenuTap,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppGaps.screenPadding),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading Action (Hamburger or Back Button)
              _buildLeadingButton(context),

              AppGaps.mediumH,

              // Title & Subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                          height: hasSubtitle ? 1.2 : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (hasSubtitle) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              if (actions != null) ...[
                AppGaps.mediumH,
                ...actions!.map(
                  (action) => Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: action,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();
    final bool isBack = showBackButton || (canPop && onMenuTap == null);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isBack) {
            Navigator.of(context).pop();
          } else if (onMenuTap != null) {
            onMenuTap!();
          } else {
            Scaffold.maybeOf(context)?.openDrawer();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey, width: 1),
          ),
          child: Icon(
            isBack ? Iconsax.arrow_left_2 : Iconsax.menu_1,
            color: AppColors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(76.0);
}

class PremiumAppbarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasNotification;

  const PremiumAppbarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey, width: 1),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: AppColors.black, size: 20),
              if (hasNotification)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
