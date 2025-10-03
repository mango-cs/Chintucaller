import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VolumeSliderWidget extends StatelessWidget {
  final double volume;
  final Function(double) onVolumeChanged;

  const VolumeSliderWidget({
    Key? key,
    required this.volume,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'volume_up',
                color: AppTheme.activeGreen,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Preview Volume',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '${(volume * 100).round()}%',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.activeGreen,
              inactiveTrackColor: AppTheme.borderSubtle,
              thumbColor: AppTheme.activeGreen,
              overlayColor: AppTheme.activeGreen.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: volume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: onVolumeChanged,
            ),
          ),
        ],
      ),
    );
  }
}
