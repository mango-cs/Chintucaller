import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OverallProgressHeader extends StatelessWidget {
  final int overallProgress;
  final String estimatedTime;
  final bool isDualSim;

  const OverallProgressHeader({
    Key? key,
    required this.overallProgress,
    required this.estimatedTime,
    this.isDualSim = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Setting up AI Assistant',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$overallProgress%',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.activeGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: overallProgress / 100,
            backgroundColor: AppTheme.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.activeGreen),
            minHeight: 1.h,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.textSecondary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Estimated time: $estimatedTime',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          if (isDualSim) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.warningAmber,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Dual SIM detected - configuring both lines',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningAmber,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
