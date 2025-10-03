import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionCardWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String description;
  final bool isGranted;
  final VoidCallback? onTap;

  const PermissionCardWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.description,
    this.isGranted = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
        border: isGranted
            ? Border.all(color: AppTheme.activeGreen, width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isGranted
                        ? AppTheme.activeGreen.withValues(alpha: 0.1)
                        : AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: isGranted ? 'check_circle' : iconName,
                      color: isGranted
                          ? AppTheme.activeGreen
                          : AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: isGranted
                              ? AppTheme.activeGreen
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isGranted)
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.activeGreen,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
