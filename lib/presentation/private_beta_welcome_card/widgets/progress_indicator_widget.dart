import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 8.w : 2.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: isActive || isCompleted
                  ? AppTheme.activeGreen
                  : AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
