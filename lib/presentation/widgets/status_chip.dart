import 'package:flutter/widgets.dart';
import 'package:visitor_management/core/constants/app_colors.dart';
import 'package:visitor_management/core/constants/app_numbers.dart';
import 'package:visitor_management/core/constants/app_strings.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case AppStrings.statusCheckedIn:
        return AppColors.checkedIn;
      case AppStrings.statusCheckedOut:
        return AppColors.checkedOut;
      default:
        return AppColors.registered;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppNumbers.spaceMd,
        vertical: AppNumbers.spaceXs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppNumbers.radiusChip),
        border: Border.all(color: _color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
