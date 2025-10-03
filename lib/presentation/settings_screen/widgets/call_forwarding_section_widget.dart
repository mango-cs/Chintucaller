import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallForwardingSectionWidget extends StatelessWidget {
  final bool sim1Enabled;
  final bool sim2Enabled;
  final Function(bool) onSim1Changed;
  final Function(bool) onSim2Changed;
  final VoidCallback onAdvancedSetup;

  const CallForwardingSectionWidget({
    Key? key,
    required this.sim1Enabled,
    required this.sim2Enabled,
    required this.onSim1Changed,
    required this.onSim2Changed,
    required this.onAdvancedSetup,
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
            'Call Forwarding',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSimToggle(
            'SIM 1 - Primary',
            'Airtel',
            sim1Enabled,
            onSim1Changed,
          ),
          SizedBox(height: 2.h),
          _buildSimToggle(
            'SIM 2 - Secondary',
            'Jio',
            sim2Enabled,
            onSim2Changed,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningAmber.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.warningAmber,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Call forwarding uses GSM codes (*004*, *67*, *62*, *61*) to redirect calls to AI assistant',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningAmber,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: onAdvancedSetup,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Advanced Setup',
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

  Widget _buildSimToggle(
      String title, String carrier, bool enabled, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                carrier,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: AppTheme.activeGreen,
          inactiveThumbColor: AppTheme.textSecondary,
          inactiveTrackColor: AppTheme.borderSubtle,
        ),
      ],
    );
  }
}
