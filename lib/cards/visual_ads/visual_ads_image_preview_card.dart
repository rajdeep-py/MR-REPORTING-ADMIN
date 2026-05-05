import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class VisualAdsImagePreviewCard extends StatelessWidget {
  final String imagePath;
  const VisualAdsImagePreviewCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.white, size: 32),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.black.withAlpha(50),
              ),
              clipBehavior: Clip.antiAlias,
              child: InteractiveViewer(
                child: Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.error, color: AppColors.white, size: 40),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
