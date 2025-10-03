import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onViewAllCalls;
  final VoidCallback onChangeProfile;
  final VoidCallback onAssistantSettings;
  final bool hasActiveCall;
  final VoidCallback? onJoinCall;

  const QuickActionsWidget({
    Key? key,
    required this.onViewAllCalls,
    required this.onChangeProfile,
    required this.onAssistantSettings,
    this.hasActiveCall = false,
    this.onJoinCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'View All Calls',
                  'call_received',
                  AppTheme.activeGreen,
                  onViewAllCalls,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  'Change Profile',
                  'person',
                  AppTheme.successTeal,
                  onChangeProfile,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Assistant Settings',
                  'settings',
                  AppTheme.warningAmber,
                  onAssistantSettings,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: hasActiveCall && onJoinCall != null
                    ? _buildActionButton(
                        'Join Live Call',
                        'call',
                        AppTheme.errorRed,
                        onJoinCall!,
                      )
                    : _buildDisabledButton('No Active Call'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String title, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.contentSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledButton(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'call_end',
                color: AppTheme.textSecondary,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
