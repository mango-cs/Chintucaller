import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VoiceOptionCard extends StatelessWidget {
  final String voiceType;
  final String voiceName;
  final String description;
  final String avatarUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPreview;
  final bool isPlaying;

  const VoiceOptionCard({
    Key? key,
    required this.voiceType,
    required this.voiceName,
    required this.description,
    required this.avatarUrl,
    required this.isSelected,
    required this.onTap,
    required this.onPreview,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.contentSurface,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppTheme.activeGreen, width: 2)
              : Border.all(color: AppTheme.borderSubtle, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.activeGreen
                          : AppTheme.borderSubtle,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: avatarUrl,
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                // Voice info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            voiceName,
                            style: AppTheme.darkTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: voiceType == 'Male'
                                  ? AppTheme.activeGreen.withValues(alpha: 0.1)
                                  : AppTheme.successTeal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              voiceType,
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: voiceType == 'Male'
                                    ? AppTheme.activeGreen
                                    : AppTheme.successTeal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                if (isSelected)
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: AppTheme.activeGreen,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.primaryBlack,
                      size: 16,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 3.h),
            // Preview button
            GestureDetector(
              onTap: onPreview,
              child: Container(
                width: double.infinity,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isPlaying
                      ? AppTheme.activeGreen.withValues(alpha: 0.1)
                      : AppTheme.borderSubtle.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPlaying
                        ? AppTheme.activeGreen
                        : AppTheme.borderSubtle,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? AppTheme.activeGreen
                            : AppTheme.textSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: isPlaying ? 'pause' : 'play_arrow',
                        color: isPlaying
                            ? AppTheme.primaryBlack
                            : AppTheme.textPrimary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      isPlaying ? 'Playing Preview...' : 'Preview Voice',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: isPlaying
                            ? AppTheme.activeGreen
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
