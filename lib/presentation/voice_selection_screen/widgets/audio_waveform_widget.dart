import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AudioWaveformWidget extends StatefulWidget {
  final bool isPlaying;
  final Duration duration;
  final Duration position;

  const AudioWaveformWidget({
    Key? key,
    required this.isPlaying,
    required this.duration,
    required this.position,
  }) : super(key: key);

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  PlayerController? _playerController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _playerController = PlayerController();
  }

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 8.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.activeGreen.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'graphic_eq',
                color: AppTheme.activeGreen,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Playing Preview',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.activeGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                '${widget.position.inSeconds}s / ${widget.duration.inSeconds}s',
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          // Animated waveform bars
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(20, (index) {
                  final height = (2 + (index % 4)) * _animation.value;
                  return Container(
                    width: 2,
                    height: height * 10,
                    decoration: BoxDecoration(
                      color: AppTheme.activeGreen.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
