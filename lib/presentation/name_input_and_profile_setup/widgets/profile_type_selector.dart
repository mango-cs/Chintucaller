import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileTypeSelector extends StatelessWidget {
  final String selectedProfile;
  final Function(String) onProfileChanged;

  const ProfileTypeSelector({
    Key? key,
    required this.selectedProfile,
    required this.onProfileChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Profile Type',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildProfileOption(
          'Personal',
          'Handles delivery notifications, personal calls, and family communications',
          'person',
          context,
        ),
        SizedBox(height: 1.5.h),
        _buildProfileOption(
          'Work',
          'Focuses on professional communications, meetings, and business calls',
          'work',
          context,
        ),
        SizedBox(height: 1.5.h),
        _buildProfileOption(
          'DND',
          'Maximum filtering with minimal interruptions, only urgent calls allowed',
          'do_not_disturb',
          context,
        ),
      ],
    );
  }

  Widget _buildProfileOption(
      String title, String description, String iconName, BuildContext context) {
    final bool isSelected = selectedProfile == title;

    return GestureDetector(
      onTap: () => onProfileChanged(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.activeGreen.withValues(alpha: 0.1)
              : AppTheme.contentSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.activeGreen : AppTheme.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppTheme.activeGreen : AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color:
                    isSelected ? AppTheme.primaryBlack : AppTheme.textSecondary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? AppTheme.activeGreen
                          : AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 11.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.activeGreen,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
