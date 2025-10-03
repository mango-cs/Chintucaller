import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CallActionButtons extends StatelessWidget {
  final VoidCallback onJoinCall;
  final VoidCallback onEndCall;
  final VoidCallback onMuteAI;
  final VoidCallback onAddNote;
  final bool isAIMuted;
  final bool isUserInCall;

  const CallActionButtons({
    Key? key,
    required this.onJoinCall,
    required this.onEndCall,
    required this.onMuteAI,
    required this.onAddNote,
    this.isAIMuted = false,
    this.isUserInCall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Primary action button - Join Call
            if (!isUserInCall) ...[
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onJoinCall();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed,
                    borderRadius: BorderRadius.circular(3.w),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.errorRed.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'call',
                        color: AppTheme.textPrimary,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Join Call Now',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Secondary action buttons
            Row(
              children: [
                // End Call button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onEndCall();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.contentSurface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: AppTheme.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'call_end',
                            color: AppTheme.errorRed,
                            size: 6.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'End Call',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Mute AI button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onMuteAI();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isAIMuted
                            ? AppTheme.warningAmber.withValues(alpha: 0.2)
                            : AppTheme.contentSurface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: isAIMuted
                              ? AppTheme.warningAmber
                              : AppTheme.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: isAIMuted ? 'mic_off' : 'mic',
                            color: isAIMuted
                                ? AppTheme.warningAmber
                                : AppTheme.textPrimary,
                            size: 6.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            isAIMuted ? 'Unmute AI' : 'Mute AI',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isAIMuted
                                  ? AppTheme.warningAmber
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Add Note button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onAddNote();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.contentSurface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: AppTheme.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'note_add',
                            color: AppTheme.textPrimary,
                            size: 6.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Add Note',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Connection quality indicator
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: AppTheme.activeGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Connection Quality: Excellent',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
