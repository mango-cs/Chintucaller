import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeHeaderWidget extends StatelessWidget {
  const WelcomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Private Beta Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.activeGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.activeGreen.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Private Beta',
            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.activeGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 3.h),

        // Rickshaw Illustration Placeholder
        Container(
          width: 60.w,
          height: 25.h,
          decoration: BoxDecoration(
            color: AppTheme.contentSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.borderSubtle,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'support_agent',
                color: AppTheme.activeGreen,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'AI Assistant',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Handling calls while you stay productive',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        // Main Heading
        Text(
          'Welcome to Smart Call Assistant',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),

        // Subtitle
        Text(
          'Never miss important calls again. Our AI assistant handles unknown callers, provides live transcription, and lets you take over anytime.',
          style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
