import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const Divider(color: AppColors.lightGrey),
          const SizedBox(height: 16),
          Text(
            '© ${DateTime.now().year} MR Admin Portal. All rights reserved.',
            style: const TextStyle(
              color: AppColors.darkGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              color: AppColors.darkGrey.withAlpha(150),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
