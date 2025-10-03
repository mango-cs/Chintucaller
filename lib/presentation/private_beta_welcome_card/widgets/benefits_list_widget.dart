import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class BenefitsListWidget extends StatefulWidget {
  const BenefitsListWidget({super.key});

  @override
  State<BenefitsListWidget> createState() => _BenefitsListWidgetState();
}

class _BenefitsListWidgetState extends State<BenefitsListWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> benefits = [
    {
      "icon": "phone",
      "title": "Never Miss Important Calls",
      "description":
          "AI answers when you're busy, unreachable, or can't pick up",
    },
    {
      "icon": "smart_toy",
      "title": "AI Handles Unknown Callers",
      "description": "Intelligent conversations in Hindi, English, and Telugu",
    },
    {
      "icon": "transcribe",
      "title": "Live Transcription & Takeover",
      "description": "See real-time conversation and jump in anytime",
    },
    {
      "icon": "description",
      "title": "Smart Call Summaries",
      "description":
          "Get structured summaries with caller intent and action items",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Benefits',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 3.h),

        // Slider with PageView
        SizedBox(
          height: 20.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: benefits.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                child: _buildBenefitItem(
                  iconName: benefits[index]["icon"] as String,
                  title: benefits[index]["title"] as String,
                  description: benefits[index]["description"] as String,
                ),
              );
            },
          ),
        ),

        SizedBox(height: 2.h),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            benefits.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: _currentIndex == index ? 8.w : 2.w,
              height: 1.h,
              decoration: BoxDecoration(
                color:
                    _currentIndex == index
                        ? AppTheme.activeGreen
                        : AppTheme.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem({
    required String iconName,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.activeGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.activeGreen,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            description,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
