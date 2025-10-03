import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AudioWaveformWidget extends StatefulWidget {
  final bool isActive;
  final double activityLevel;

  const AudioWaveformWidget({
    Key? key,
    required this.isActive,
    this.activityLevel = 0.5,
  }) : super(key: key);

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<double> _waveformData = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Initialize waveform data
    _generateWaveformData();

    if (widget.isActive) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  void _generateWaveformData() {
    _waveformData.clear();
    for (int i = 0; i < 20; i++) {
      _waveformData.add(0.1 + (widget.activityLevel * 0.9));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          // Microphone icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppTheme.activeGreen
                  : AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: widget.isActive ? 'mic' : 'mic_off',
              color: AppTheme.primaryBlack,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          // Waveform visualization
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(15, (index) {
                    final baseHeight = widget.isActive
                        ? (0.3 + (widget.activityLevel * 0.7)) * 4.h
                        : 0.5.h;

                    final animatedHeight = widget.isActive
                        ? baseHeight *
                            (0.5 +
                                0.5 * (1 + (index % 3 - 1) * _animation.value))
                        : baseHeight;

                    return Container(
                      width: 0.8.w,
                      height: animatedHeight.clamp(0.5.h, 4.h),
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? AppTheme.activeGreen
                            : AppTheme.textSecondary,
                        borderRadius: BorderRadius.circular(0.4.w),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          SizedBox(width: 3.w),
          // Activity indicator
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isActive ? 'LIVE' : 'MUTED',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: widget.isActive
                      ? AppTheme.activeGreen
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? AppTheme.activeGreen
                      : AppTheme.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
