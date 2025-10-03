import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../routes/app_routes.dart';

/// DEV ONLY: Navigation drawer to quickly access all screens for UI testing
/// Remove this before production!
class DevNavigationDrawer extends StatelessWidget {
  const DevNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                border: Border(
                  bottom: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.construction, color: Colors.orange, size: 8.w),
                      SizedBox(width: 2.w),
                      Text(
                        'DEV NAVIGATION',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '⚠️ Testing Only - Remove Before Production',
                    style: TextStyle(
                      color: Colors.orange.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation List
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildSectionHeader('Authentication Flow'),
                  _buildNavTile(
                    context,
                    icon: Icons.login,
                    title: 'Phone Login',
                    route: AppRoutes.phoneLogin,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.pin,
                    title: 'OTP Verification',
                    route: AppRoutes.otpVerification,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.email,
                    title: 'Email Login',
                    route: AppRoutes.login,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.person_add,
                    title: 'Signup',
                    route: AppRoutes.signup,
                  ),

                  _buildSectionHeader('Setup Flow'),
                  _buildNavTile(
                    context,
                    icon: Icons.security,
                    title: 'Permission Request',
                    route: AppRoutes.permissionRequest,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.account_circle,
                    title: 'Name & Profile Setup',
                    route: AppRoutes.nameInputAndProfileSetup,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.record_voice_over,
                    title: 'Voice Selection',
                    route: AppRoutes.voiceSelection,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.celebration,
                    title: 'Beta Welcome',
                    route: AppRoutes.privateBetaWelcomeCard,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.hourglass_bottom,
                    title: 'Activating Progress',
                    route: AppRoutes.activatingAssistantProgress,
                  ),

                  _buildSectionHeader('Main App'),
                  _buildNavTile(
                    context,
                    icon: Icons.home,
                    title: 'Home Dashboard',
                    route: AppRoutes.homeDashboard,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.call,
                    title: 'Call History',
                    route: AppRoutes.callHistory,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.analytics,
                    title: 'Analytics',
                    route: AppRoutes.analytics,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.phone_in_talk,
                    title: 'Live Call',
                    route: AppRoutes.liveCall,
                  ),
                  _buildNavTile(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    route: AppRoutes.settings,
                  ),

                  _buildSectionHeader('Other'),
                  _buildNavTile(
                    context,
                    icon: Icons.flash_on,
                    title: 'Splash Screen',
                    route: AppRoutes.splash,
                  ),
                ],
              ),
            ),

            // Close button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[800]!, width: 1),
                ),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  foregroundColor: Colors.white,
                ),
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFCDFF00), size: 6.w),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[700], size: 4.w),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}

