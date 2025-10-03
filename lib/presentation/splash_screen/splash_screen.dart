import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing AI services...';
  double _progress = 0.0;
  bool _showRetryOption = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _hideSystemUI();
    _startInitialization();
  }

  void _setupAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
    _loadingAnimationController.repeat();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Check authentication status
      await _updateProgress(0.2, 'Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 500));
      bool isAuthenticated = await _checkAuthenticationStatus();

      // Step 2: Verify call forwarding configuration
      await _updateProgress(0.4, 'Verifying call forwarding...');
      await Future.delayed(const Duration(milliseconds: 600));
      bool isCallForwardingConfigured = await _verifyCallForwarding();

      // Step 3: Load user profiles
      await _updateProgress(0.6, 'Loading user profiles...');
      await Future.delayed(const Duration(milliseconds: 500));
      bool profilesLoaded = await _loadUserProfiles();

      // Step 4: Prepare cached call data
      await _updateProgress(0.8, 'Preparing call data...');
      await Future.delayed(const Duration(milliseconds: 400));
      bool dataReady = await _prepareCachedData();

      // Step 5: Initialize AI services
      await _updateProgress(1.0, 'AI services ready!');
      await Future.delayed(const Duration(milliseconds: 300));

      // Determine navigation path
      _navigateToNextScreen(
          isAuthenticated, isCallForwardingConfigured, profilesLoaded);
    } catch (e) {
      _handleInitializationError();
    }
  }

  Future<void> _updateProgress(double progress, String status) async {
    if (mounted) {
      setState(() {
        _progress = progress;
        _initializationStatus = status;
      });
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate authentication check
    return await Future.delayed(const Duration(milliseconds: 300), () => false);
  }

  Future<bool> _verifyCallForwarding() async {
    // Simulate call forwarding verification
    return await Future.delayed(const Duration(milliseconds: 400), () => false);
  }

  Future<bool> _loadUserProfiles() async {
    // Simulate profile loading
    return await Future.delayed(const Duration(milliseconds: 200), () => true);
  }

  Future<bool> _prepareCachedData() async {
    // Simulate data preparation
    return await Future.delayed(const Duration(milliseconds: 250), () => true);
  }

  void _navigateToNextScreen(
      bool isAuthenticated, bool isConfigured, bool profilesLoaded) {
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          if (isAuthenticated && isConfigured && profilesLoaded) {
            // Configured users go to home dashboard
            Navigator.pushReplacementNamed(context, '/home-dashboard');
          } else if (!isAuthenticated) {
            // New users see phone login
            Navigator.pushReplacementNamed(context, '/phone-login');
          } else {
            // Users with incomplete setup reach voice selection
            Navigator.pushReplacementNamed(context, '/voice-selection-screen');
          }
        }
      });
    }
  }

  void _handleInitializationError() {
    if (mounted) {
      setState(() {
        _isInitializing = false;
        _showRetryOption = true;
        _initializationStatus =
            'Connection timeout. Please check your network.';
      });

      // Show retry option after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _showRetryOption) {
          setState(() {
            _showRetryOption = true;
          });
        }
      });
    }
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _showRetryOption = false;
      _progress = 0.0;
      _initializationStatus = 'Retrying initialization...';
    });
    _startInitialization();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBlack,
              AppTheme.contentSurface,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: _buildAppLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInitializationStatus(),
                      SizedBox(height: 4.h),
                      _buildProgressIndicator(),
                      SizedBox(height: 6.h),
                      _showRetryOption
                          ? _buildRetryButton()
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.activeGreen,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.activeGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'phone',
            color: AppTheme.primaryBlack,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'AI',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryBlack,
              fontWeight: FontWeight.w800,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitializationStatus() {
    return Column(
      children: [
        Text(
          'Equal AI Assistant',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          _initializationStatus,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return _isInitializing
        ? Column(
            children: [
              Container(
                width: 70.w,
                height: 0.8.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(1.h),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1.h),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.activeGreen,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${(_progress * 100).toInt()}%',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.activeGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          )
        : AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Container(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  value: _showRetryOption ? null : _loadingAnimation.value,
                  strokeWidth: 0.5.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _showRetryOption ? AppTheme.errorRed : AppTheme.activeGreen,
                  ),
                  backgroundColor: AppTheme.borderSubtle,
                ),
              );
            },
          );
  }

  Widget _buildRetryButton() {
    return Container(
      width: 60.w,
      child: ElevatedButton(
        onPressed: _retryInitialization,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.activeGreen,
          foregroundColor: AppTheme.primaryBlack,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.primaryBlack,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Retry',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryBlack,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
