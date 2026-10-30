import 'package:flutter/material.dart';
import 'package:visitor_management/core/constants/app_colors.dart';

import '../../core/constants/app_numbers.dart';
import '../../core/constants/app_strings.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppNumbers.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: AppNumbers.iconSizeLg,
              color: AppColors.error,
            ),
            const SizedBox(height: AppNumbers.spaceLg),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppNumbers.spaceLg),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
