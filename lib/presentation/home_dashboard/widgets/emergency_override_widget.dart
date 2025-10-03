import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyOverrideWidget extends StatelessWidget {
  final bool isOverrideActive;
  final VoidCallback onToggleOverride;
  final int? remainingMinutes;

  const EmergencyOverrideWidget({
    Key? key,
    required this.isOverrideActive,
    required this.onToggleOverride,
    this.remainingMinutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: isOverrideActive
            ? AppTheme.warningAmber.withValues(alpha: 0.1)
            : AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isOverrideActive ? AppTheme.warningAmber : AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isOverrideActive
                  ? AppTheme.warningAmber.withValues(alpha: 0.2)
                  : AppTheme.textSecondary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: isOverrideActive ? 'warning' : 'shield',
                color: isOverrideActive
                    ? AppTheme.warningAmber
                    : AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Override',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isOverrideActive
                      ? remainingMinutes != null
                          ? 'Assistant disabled for $remainingMinutes minutes'
                          : 'Assistant temporarily disabled'
                      : 'Temporarily disable AI assistant for important calls',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onToggleOverride,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: isOverrideActive
                    ? AppTheme.errorRed
                    : AppTheme.warningAmber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isOverrideActive ? 'Disable' : 'Enable',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
