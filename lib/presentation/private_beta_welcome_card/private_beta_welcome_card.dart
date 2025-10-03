import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/benefits_list_widget.dart';
import './widgets/expandable_learn_more_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/welcome_header_widget.dart';

class PrivateBetaWelcomeCard extends StatefulWidget {
  const PrivateBetaWelcomeCard({super.key});

  @override
  State<PrivateBetaWelcomeCard> createState() => _PrivateBetaWelcomeCardState();
}

class _PrivateBetaWelcomeCardState extends State<PrivateBetaWelcomeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGetStarted() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/voice-selection-screen');
  }

  void _handleSkip() {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, '/home-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Skip button in top-right corner
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _handleSkip,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Skip',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),

                // Welcome Header
                const WelcomeHeaderWidget(),
                SizedBox(height: 4.h),

                // Benefits List
                const BenefitsListWidget(),
                SizedBox(height: 4.h),

                // Learn More Expandable Section
                const ExpandableLearnMoreWidget(),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),

        // Bottom section with progress and buttons
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlack,
            border: Border(
              top: BorderSide(
                color: AppTheme.borderSubtle,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Progress Indicator
              const ProgressIndicatorWidget(
                currentStep: 0,
                totalSteps: 4,
              ),
              SizedBox(height: 1.h),

              // Step indicator text
              Text(
                '1 of 4',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 3.h),

              // Action Buttons
              ActionButtonsWidget(
                onGetStarted: _handleGetStarted,
                onSkip: _handleSkip,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
