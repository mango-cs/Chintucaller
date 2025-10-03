import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsMenuItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final bool showChevron;

  const SettingsMenuItemWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.iconName,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.showChevron = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: iconColor ?? AppTheme.textSecondary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle!,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: 2.w),
            ],
            if (showChevron && onTap != null)
              CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
