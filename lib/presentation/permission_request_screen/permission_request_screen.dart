import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/expandable_info_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/permission_illustration_widget.dart';
import './widgets/permission_progress_widget.dart';

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({Key? key}) : super(key: key);

  @override
  State<PermissionRequestScreen> createState() =>
      _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  final Map<String, bool> _permissionStatus = {
    'phone': false,
    'contacts': false,
    'microphone': false,
    'notification': false,
    'storage': false,
  };

  final List<Map<String, dynamic>> _permissionData = [
    {
      'key': 'phone',
      'icon': 'phone',
      'title': 'Phone Access',
      'description':
          'Monitor call state and enable AI assistant to handle incoming calls automatically',
      'permission': Permission.phone,
    },
    {
      'key': 'contacts',
      'icon': 'contacts',
      'title': 'Contacts',
      'description':
          'Identify known callers and apply personalized call handling rules',
      'permission': Permission.contacts,
    },
    {
      'key': 'microphone',
      'icon': 'mic',
      'title': 'Microphone',
      'description':
          'Record and transcribe conversations for AI processing and call summaries',
      'permission': Permission.microphone,
    },
    {
      'key': 'notification',
      'icon': 'notifications',
      'title': 'Notifications',
      'description':
          'Send instant call summaries, alerts, and important messages',
      'permission': Permission.notification,
    },
    {
      'key': 'storage',
      'icon': 'storage',
      'title': 'Storage',
      'description':
          'Securely store encrypted call transcripts and summaries locally',
      'permission': Permission.storage,
    },
  ];

  bool _isRequestingPermissions = false;
  bool _showSkipWarning = false;

  @override
  void initState() {
    super.initState();
    _checkExistingPermissions();
  }

  Future<void> _checkExistingPermissions() async {
    for (final permissionData in _permissionData) {
      final permission = permissionData['permission'] as Permission;
      final status = await permission.status;
      setState(() {
        _permissionStatus[permissionData['key']] = status.isGranted;
      });
    }
  }

  Future<void> _requestPermission(String key) async {
    final permissionData = _permissionData.firstWhere((p) => p['key'] == key);
    final permission = permissionData['permission'] as Permission;

    try {
      final status = await permission.request();
      setState(() {
        _permissionStatus[key] = status.isGranted;
      });

      if (status.isGranted) {
        HapticFeedback.lightImpact();
      } else if (status.isPermanentlyDenied) {
        _showPermissionDeniedDialog(permissionData['title']);
      }
    } catch (e) {
      _showErrorSnackBar(
          'Failed to request ${permissionData['title']} permission');
    }
  }

  Future<void> _requestAllPermissions() async {
    if (_isRequestingPermissions) return;

    setState(() {
      _isRequestingPermissions = true;
    });

    try {
      for (final permissionData in _permissionData) {
        if (!_permissionStatus[permissionData['key']]!) {
          await _requestPermission(permissionData['key']);
          // Small delay between permission requests for better UX
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      // Check if all critical permissions are granted
      final criticalPermissions = ['phone', 'contacts', 'microphone'];
      final allCriticalGranted = criticalPermissions.every(
        (key) => _permissionStatus[key] == true,
      );

      if (allCriticalGranted) {
        HapticFeedback.mediumImpact();
        _navigateToNextScreen();
      } else {
        _showIncompletePermissionsDialog();
      }
    } finally {
      setState(() {
        _isRequestingPermissions = false;
      });
    }
  }

  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.contentSurface,
        title: Text(
          'Permission Required',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          '$permissionName permission is required for the AI assistant to function properly. Please enable it in Settings.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showIncompletePermissionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.contentSurface,
        title: Text(
          'Setup Incomplete',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.warningAmber,
          ),
        ),
        content: Text(
          'Some critical permissions are missing. The AI assistant may not work properly without Phone, Contacts, and Microphone access.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSkipConfirmation();
            },
            child: Text(
              'Continue Anyway',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _requestAllPermissions();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showSkipConfirmation() {
    setState(() {
      _showSkipWarning = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.contentSurface,
        title: Text(
          'Limited Functionality',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.errorRed,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Without proper permissions, you will experience:',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            _buildLimitationItem('• No automatic call handling'),
            _buildLimitationItem('• No caller identification'),
            _buildLimitationItem('• No call recording or transcription'),
            _buildLimitationItem('• No call summaries or notifications'),
            SizedBox(height: 2.h),
            Text(
              'Are you sure you want to continue?',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showSkipWarning = false;
              });
            },
            child: Text(
              'Go Back',
              style: TextStyle(color: AppTheme.activeGreen),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            onPressed: () {
              Navigator.pop(context);
              _navigateToNextScreen();
            },
            child: const Text('Continue Anyway'),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitationItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Text(
        text,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.errorRed,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToNextScreen() {
    Navigator.pushNamed(context, '/private-beta-welcome-card');
  }

  void _handleBackPress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.contentSurface,
        title: Text(
          'Exit Setup?',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Your AI assistant setup is incomplete. Exiting now will prevent the app from working properly.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue Setup',
              style: TextStyle(color: AppTheme.activeGreen),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            child: const Text('Exit App'),
          ),
        ],
      ),
    );
  }

  int get _grantedPermissionsCount {
    return _permissionStatus.values.where((granted) => granted).length;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryBlack,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _handleBackPress,
                      child: Container(
                        width: 10.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: AppTheme.contentSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'Setup Permissions',
                        style: AppTheme.darkTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),

                      // Illustration
                      const PermissionIllustrationWidget(),

                      SizedBox(height: 3.h),

                      // Title and description
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          children: [
                            Text(
                              'Enable AI Call Assistant',
                              textAlign: TextAlign.center,
                              style: AppTheme.darkTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Grant these permissions to let your AI assistant handle calls, identify callers, and provide intelligent summaries.',
                              textAlign: TextAlign.center,
                              style: AppTheme.darkTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Progress indicator
                      PermissionProgressWidget(
                        grantedCount: _grantedPermissionsCount,
                        totalCount: _permissionData.length,
                      ),

                      SizedBox(height: 2.h),

                      // Permission cards
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _permissionData.length,
                        itemBuilder: (context, index) {
                          final permission = _permissionData[index];
                          return PermissionCardWidget(
                            iconName: permission['icon'],
                            title: permission['title'],
                            description: permission['description'],
                            isGranted:
                                _permissionStatus[permission['key']] ?? false,
                            onTap: () => _requestPermission(permission['key']),
                          );
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Expandable info section
                      const ExpandableInfoWidget(),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.contentSurface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    // Grant permissions button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: _isRequestingPermissions
                            ? null
                            : _requestAllPermissions,
                        child: _isRequestingPermissions
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                    height: 2.5.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.primaryBlack,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'Requesting Permissions...',
                                    style: AppTheme
                                        .darkTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme.primaryBlack,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Grant All Permissions',
                                style: AppTheme.darkTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.primaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Skip button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: _showSkipConfirmation,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _showSkipWarning
                                ? AppTheme.errorRed
                                : AppTheme.borderSubtle,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_showSkipWarning) ...[
                              CustomIconWidget(
                                iconName: 'warning',
                                color: AppTheme.errorRed,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                            ],
                            Text(
                              'Skip for Now',
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: _showSkipWarning
                                    ? AppTheme.errorRed
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
    );
  }
}