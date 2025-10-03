import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatisticsCardWidget extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const StatisticsCardWidget({
    Key? key,
    required this.statistics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int todayCalls = statistics['todayCalls'] as int? ?? 0;
    final int weekCalls = statistics['weekCalls'] as int? ?? 0;
    final int spamBlocked = statistics['spamBlocked'] as int? ?? 0;
    final double efficiency = statistics['efficiency'] as double? ?? 0.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.textPrimary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Call Statistics',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Today',
                  todayCalls.toString(),
                  'calls handled',
                  AppTheme.activeGreen,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  'This Week',
                  weekCalls.toString(),
                  'total calls',
                  AppTheme.successTeal,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Spam Blocked',
                  spamBlocked.toString(),
                  'unwanted calls',
                  AppTheme.errorRed,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildEfficiencyItem(efficiency),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyItem(double efficiency) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Efficiency',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Text(
                '${efficiency.toInt()}%',
                style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                  color: _getEfficiencyColor(efficiency),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: efficiency / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getEfficiencyColor(efficiency),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            'call success rate',
            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 90) return AppTheme.activeGreen;
    if (efficiency >= 75) return AppTheme.successTeal;
    if (efficiency >= 50) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }
}
