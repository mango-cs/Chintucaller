import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionIllustrationWidget extends StatelessWidget {
  const PermissionIllustrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 25.h,
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone illustration background
          Container(
            width: 40.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlack,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Phone screen
                Container(
                  width: 30.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: AppTheme.contentSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.activeGreen,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'AI Assistant',
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                // Phone buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 8.w,
                      height: 1.h,
                      decoration: BoxDecoration(
                        color: AppTheme.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(
                      width: 8.w,
                      height: 1.h,
                      decoration: BoxDecoration(
                        color: AppTheme.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // AI assistant indicator
          Positioned(
            top: 2.h,
            right: 8.w,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppTheme.activeGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'smart_toy',
                  color: AppTheme.primaryBlack,
                  size: 16,
                ),
              ),
            ),
          ),
          // Permission indicators
          Positioned(
            bottom: 2.h,
            left: 6.w,
            child: Row(
              children: [
                _buildPermissionDot(AppTheme.activeGreen),
                SizedBox(width: 1.w),
                _buildPermissionDot(AppTheme.warningAmber),
                SizedBox(width: 1.w),
                _buildPermissionDot(AppTheme.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDot(Color color) {
    return Container(
      width: 2.w,
      height: 1.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
