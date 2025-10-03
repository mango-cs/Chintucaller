import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatusCardWidget extends StatelessWidget {
  final bool isAssistantActive;
  final String currentProfile;
  final VoidCallback onToggleAssistant;
  final VoidCallback onChangeProfile;

  const StatusCardWidget({
    Key? key,
    required this.isAssistantActive,
    required this.currentProfile,
    required this.onToggleAssistant,
    required this.onChangeProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      isAssistantActive
                          ? 'Actively managing your calls'
                          : 'Currently disabled',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggleAssistant,
                child: Container(
                  width: 15.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isAssistantActive
                        ? AppTheme.activeGreen
                        : AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: isAssistantActive
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 7.w,
                      height: 7.w,
                      margin: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.textPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Profile',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      currentProfile,
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onChangeProfile,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.contentSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.borderSubtle,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Change',
                      style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.activeGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
