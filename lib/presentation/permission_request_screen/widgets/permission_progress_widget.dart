import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PermissionProgressWidget extends StatelessWidget {
  final int grantedCount;
  final int totalCount;

  const PermissionProgressWidget({
    Key? key,
    required this.grantedCount,
    required this.totalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? grantedCount / totalCount : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Setup Progress',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$grantedCount/$totalCount',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.activeGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 0.8.h,
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.activeGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: List.generate(totalCount, (index) {
              final isCompleted = index < grantedCount;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 2.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.activeGreen
                              : AppTheme.borderSubtle,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
