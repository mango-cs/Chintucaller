import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:pinput/pinput.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io' show Platform;
import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/dev_navigation_drawer.dart';
import '../../services/permission_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  int _resendTimer = 30;
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get phone number from navigation arguments
    _phoneNumber = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate OTP verification (replace with actual verification later)
      await Future.delayed(Duration(milliseconds: 800));

      if (mounted) {
        // Request Default Dialer & Phone Permissions
        await _requestDialerPermissions();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestDialerPermissions() async {
    // Show dialog explaining why we need these permissions
    final shouldProceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Set as Default Phone App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To manage your calls with AI, we need to:',
              style: TextStyle(color: Colors.grey[300]),
            ),
            SizedBox(height: 2.h),
            _buildPermissionItem('📞', 'Set as default dialer app'),
            _buildPermissionItem('🛡️', 'Screen spam calls automatically'),
            _buildPermissionItem('🎙️', 'Access phone calls for AI handling'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Skip for Now', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFCDFF00),
              foregroundColor: Colors.black,
            ),
            child: Text('Continue'),
          ),
        ],
      ),
    );

    if (shouldProceed == true) {
      // Request phone permissions
      await PermissionService.requestPhonePermissions();

      // Request to set as default dialer (Android specific)
      if (Platform.isAndroid) {
        try {
          final intent = AndroidIntent(
            action: 'android.telecom.action.CHANGE_DEFAULT_DIALER',
            package: 'com.equal_ai_assistant.app',
          );
          await intent.launch();
        } catch (e) {
          print('Error setting default dialer: $e');
        }
      }

      // Wait a bit for user to interact with system dialogs
      await Future.delayed(Duration(milliseconds: 500));
    }

    // Navigate to next screen (name input)
    if (mounted) {
      Navigator.pushReplacementNamed(
          context, AppRoutes.nameInputAndProfileSetup);
    }
  }

  Widget _buildPermissionItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resendOTP() async {
    if (_resendTimer > 0) return;

    setState(() {
      _isLoading = true;
      _resendTimer = 30;
    });

    try {
      // Resend OTP logic here
      await _authService.signInWithPhone(_phoneNumber ?? '');
      _startResendTimer();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // DEVELOPMENT ONLY: Skip OTP verification for testing
  void _skipOTPForDevelopment() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ SKIPPED AUTHENTICATION - DEV MODE ONLY'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate directly to home dashboard without authentication
      Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 14.w,
      height: 6.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFCDFF00), width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const DevNavigationDrawer(), // DEV ONLY
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.construction, color: Colors.orange),
            tooltip: 'DEV: All Screens',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),

              // Progress indicator
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color(0xFFCDFF00),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color(0xFFCDFF00),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Title
              Text(
                'Enter OTP sent to',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 1.h),

              // Phone number with edit icon
              Row(
                children: [
                  Text(
                    _phoneNumber ?? '+91-XXXXXXXXXX',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey[400],
                      size: 4.w,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // OTP input
              Center(
                child: Pinput(
                  controller: _otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Color(0xFFCDFF00), width: 3),
                    ),
                  ),
                  onCompleted: (pin) => _verifyOTP(),
                ),
              ),

              SizedBox(height: 3.h),

              // Resend timer
              Center(
                child: Text(
                  _resendTimer > 0
                      ? 'Resend in ${_resendTimer.toString().padLeft(2, '0')}:${(0).toString().padLeft(2, '0')}'
                      : 'Resend OTP',
                  style: TextStyle(
                    color:
                        _resendTimer > 0 ? Colors.grey[600] : Color(0xFFCDFF00),
                    fontSize: 11.sp,
                  ),
                ),
              ),

              Spacer(),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCDFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 5.w,
                          width: 5.w,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 2.h),

              // DEV ONLY: Navigation buttons
              Row(
                children: [
                  // Go to next step (Permission Request or Home)
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, AppRoutes.permissionRequest),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(color: Colors.blue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'NEXT',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(Icons.arrow_forward, size: 5.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // Skip to home
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: _skipOTPForDevelopment,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: BorderSide(color: Colors.orange, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.skip_next, size: 5.w),
                            SizedBox(width: 1.w),
                            Text(
                              'SKIP',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }
}
