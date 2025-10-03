import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../activating_assistant_progress.dart';
import './progress_stage_card.dart';

class DualSimProgressWidget extends StatelessWidget {
  final String simName;
  final String carrier;
  final List<ProgressStageData> stages;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;

  const DualSimProgressWidget({
    Key? key,
    required this.simName,
    required this.carrier,
    required this.stages,
    required this.isExpanded,
    required this.onToggleExpansion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedStages =
        stages.where((s) => s.status == ProgressStageStatus.completed).length;
    final totalStages = stages.length;
    final progressPercentage = (completedStages / totalStages * 100).round();

    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpansion,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.activeGreen.withValues(alpha: 0.2),
                    ),
                    child: CustomIconWidget(
                      iconName: 'sim_card',
                      color: AppTheme.activeGreen,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          simName,
                          style: AppTheme.darkTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          carrier,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: completedStages / totalStages,
                                backgroundColor: AppTheme.borderSubtle,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.activeGreen),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '$progressPercentage%',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.activeGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(color: AppTheme.borderSubtle, height: 1),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: stages
                    .map((stage) => Container(
                          width: 85.w,
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.contentSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: stage.status == ProgressStageStatus.active
                                ? Border.all(color: AppTheme.activeGreen, width: 1)
                                : null,
                          ),
                          child: Row(
                            children: [
                              _buildStatusIndicator(stage.status, stage.remainingSeconds),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stage.title,
                                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                                        color: stage.status == ProgressStageStatus.error
                                            ? AppTheme.errorRed
                                            : AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      _getDisplayDescription(stage.description, stage.status, stage.remainingSeconds),
                                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    if (stage.status == ProgressStageStatus.error &&
                                        stage.errorMessage != null) ...[ 
                                      SizedBox(height: 1.h),
                                      Text(
                                        stage.errorMessage!,
                                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                          color: AppTheme.errorRed,
                                        ),
                                      ),
                                      if (stage.onRetry != null) ...[
                                        SizedBox(height: 1.h),
                                        TextButton(
                                          onPressed: stage.onRetry,
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
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ProgressStageStatus status, int? remainingSeconds) {
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

  String _getDisplayDescription(String description, ProgressStageStatus status, int? remainingSeconds) {
    if (status == ProgressStageStatus.active && remainingSeconds != null) {
      return '$description (${remainingSeconds}s remaining)';
    }
    return description;
  }
}