import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySecurityWidget extends StatelessWidget {
  final bool recordingEnabled;
  final bool transcriptionEnabled;
  final bool dataStorageEnabled;
  final String dataRetention;
  final Function(bool) onRecordingChanged;
  final Function(bool) onTranscriptionChanged;
  final Function(bool) onDataStorageChanged;
  final Function(String) onDataRetentionChanged;

  const PrivacySecurityWidget({
    Key? key,
    required this.recordingEnabled,
    required this.transcriptionEnabled,
    required this.dataStorageEnabled,
    required this.dataRetention,
    required this.onRecordingChanged,
    required this.onTranscriptionChanged,
    required this.onDataStorageChanged,
    required this.onDataRetentionChanged,
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
            'Privacy & Security',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildToggleItem(
            'Call Recording',
            'Record calls for AI processing',
            'mic',
            recordingEnabled,
            onRecordingChanged,
          ),
          SizedBox(height: 1.5.h),
          _buildToggleItem(
            'Live Transcription',
            'Real-time speech-to-text conversion',
            'subtitles',
            transcriptionEnabled,
            onTranscriptionChanged,
          ),
          SizedBox(height: 1.5.h),
          _buildToggleItem(
            'Data Storage',
            'Store call data locally on device',
            'storage',
            dataStorageEnabled,
            onDataStorageChanged,
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () => _showDataRetentionSelector(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Retention',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'How long to keep call data',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.borderSubtle,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$dataRetention days',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'All data is encrypted and stored locally on your device',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    String title,
    String subtitle,
    String iconName,
    bool enabled,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textSecondary,
          size: 20,
        ),
        SizedBox(width: 3.w),
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
                subtitle,
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

  void _showDataRetentionSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.contentSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data Retention Period',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildRetentionOption('7', '7 days'),
              _buildRetentionOption('30', '30 days'),
              _buildRetentionOption('90', '90 days'),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRetentionOption(String value, String label) {
    return Builder(
      builder: (BuildContext context) {
        return ListTile(
          title: Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          trailing: dataRetention == value
              ? CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.activeGreen,
                  size: 20,
                )
              : null,
          onTap: () {
            onDataRetentionChanged(value);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
