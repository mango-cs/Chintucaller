import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpandableInfoWidget extends StatefulWidget {
  const ExpandableInfoWidget({Key? key}) : super(key: key);

  @override
  State<ExpandableInfoWidget> createState() => _ExpandableInfoWidgetState();
}

class _ExpandableInfoWidgetState extends State<ExpandableInfoWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'help_outline',
                      color: AppTheme.activeGreen,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Why These Permissions?',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.textSecondary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppTheme.borderSubtle,
                    height: 1,
                  ),
                  SizedBox(height: 2.h),
                  _buildInfoItem(
                    'Phone Access',
                    'Monitor incoming calls and enable AI assistant to answer automatically when you\'re busy or unreachable.',
                  ),
                  SizedBox(height: 1.5.h),
                  _buildInfoItem(
                    'Contacts',
                    'Identify known callers and apply personalized call handling rules for friends, family, and work contacts.',
                  ),
                  SizedBox(height: 1.5.h),
                  _buildInfoItem(
                    'Microphone',
                    'Record and transcribe conversations for AI processing and provide you with call summaries and action items.',
                  ),
                  SizedBox(height: 1.5.h),
                  _buildInfoItem(
                    'Notifications',
                    'Send you instant call summaries, important messages, and alerts about spam or urgent calls.',
                  ),
                  SizedBox(height: 1.5.h),
                  _buildInfoItem(
                    'Storage',
                    'Securely store encrypted call transcripts and summaries locally on your device for privacy and offline access.',
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.activeGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'security',
                          color: AppTheme.activeGreen,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'All data is encrypted and stored locally on your device. We never share your personal information.',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.activeGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
