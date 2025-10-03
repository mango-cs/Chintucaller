import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressStageCard extends StatelessWidget {
  final String title;
  final String description;
  final ProgressStageStatus status;
  final int? remainingSeconds;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ProgressStageCard({
    Key? key,
    required this.title,
    required this.description,
    required this.status,
    this.remainingSeconds,
    this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
        border: status == ProgressStageStatus.active
            ? Border.all(color: AppTheme.activeGreen, width: 1)
            : null,
      ),
      child: Row(
        children: [
          _buildStatusIndicator(),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: status == ProgressStageStatus.error
                        ? AppTheme.errorRed
                        : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _getDisplayDescription(),
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (status == ProgressStageStatus.error &&
                    errorMessage != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    errorMessage!,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorRed,
                    ),
                  ),
                  if (onRetry != null) ...[
                    SizedBox(height: 1.h),
                    TextButton(
                      onPressed: onRetry,
                      child: Text(
                        'Retry',
                        style: TextStyle(color: AppTheme.activeGreen),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    switch (status) {
      case ProgressStageStatus.pending:
        return Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.borderSubtle,
          ),
        );
      case ProgressStageStatus.active:
        return SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.activeGreen),
          ),
        );
      case ProgressStageStatus.completed:
        return Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.activeGreen,
          ),
          child: CustomIconWidget(
            iconName: 'check',
            color: AppTheme.primaryBlack,
            size: 4.w,
          ),
        );
      case ProgressStageStatus.error:
        return Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.errorRed,
          ),
          child: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.textPrimary,
            size: 4.w,
          ),
        );
    }
  }

  String _getDisplayDescription() {
    if (status == ProgressStageStatus.active && remainingSeconds != null) {
      return '$description (${remainingSeconds}s remaining)';
    }
    return description;
  }
}

enum ProgressStageStatus {
  pending,
  active,
  completed,
  error,
}
