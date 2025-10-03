import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSectionWidget extends StatelessWidget {
  final String currentProfile;
  final Function(String) onProfileChanged;

  const ProfileSectionWidget({
    Key? key,
    required this.currentProfile,
    required this.onProfileChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Profile',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.activeGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.activeGreen.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: _getProfileIcon(currentProfile),
                            color: AppTheme.activeGreen,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            currentProfile,
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.activeGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              PopupMenuButton<String>(
                onSelected: onProfileChanged,
                color: AppTheme.contentSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  _buildProfileMenuItem('Personal', 'person'),
                  _buildProfileMenuItem('Work', 'work'),
                  _buildProfileMenuItem('DND', 'do_not_disturb'),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Switch',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.textPrimary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () {
              // Navigate to profile management screen
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Manage Profiles',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildProfileMenuItem(String profile, String iconName) {
    return PopupMenuItem<String>(
      value: profile,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.textPrimary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Text(
            profile,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _getProfileIcon(String profile) {
    switch (profile) {
      case 'Personal':
        return 'person';
      case 'Work':
        return 'work';
      case 'DND':
        return 'do_not_disturb';
      default:
        return 'person';
    }
  }
}
