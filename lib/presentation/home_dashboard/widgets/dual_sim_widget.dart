import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DualSimWidget extends StatelessWidget {
  final List<Map<String, dynamic>> simData;

  const DualSimWidget({
    Key? key,
    required this.simData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                iconName: 'sim_card',
                color: AppTheme.textPrimary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Dual SIM Status',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...simData.asMap().entries.map((entry) {
            final index = entry.key;
            final sim = entry.value;
            return Container(
              margin:
                  EdgeInsets.only(bottom: index < simData.length - 1 ? 2.h : 0),
              child: _buildSimCard(sim),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSimCard(Map<String, dynamic> sim) {
    final bool isForwardingActive = sim['forwardingActive'] as bool? ?? false;
    final String carrierName = sim['carrierName'] as String? ?? 'Unknown';
    final String simNumber = sim['simNumber'] as String? ?? 'SIM';
    final int signalStrength = sim['signalStrength'] as int? ?? 0;

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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      simNumber,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: isForwardingActive
                            ? AppTheme.activeGreen
                            : AppTheme.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  carrierName,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  isForwardingActive
                      ? 'Forwarding Active'
                      : 'Forwarding Disabled',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: isForwardingActive
                        ? AppTheme.activeGreen
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              CustomIconWidget(
                iconName: 'signal_cellular_4_bar',
                color: _getSignalColor(signalStrength),
                size: 20,
              ),
              SizedBox(height: 1.h),
              Text(
                '$signalStrength%',
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSignalColor(int strength) {
    if (strength >= 75) return AppTheme.activeGreen;
    if (strength >= 50) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }
}
