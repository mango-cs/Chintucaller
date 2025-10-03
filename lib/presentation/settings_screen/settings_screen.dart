import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/call_forwarding_section_widget.dart';
import './widgets/language_preferences_widget.dart';
import './widgets/privacy_security_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/settings_menu_item_widget.dart';
import './widgets/settings_section_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Profile settings
  String _currentProfile = 'Personal';

  // Call forwarding settings
  bool _sim1Enabled = true;
  bool _sim2Enabled = false;

  // Language settings
  String _primaryLanguage = 'English';
  String _aiVoiceLanguage = 'Hindi';

  // Privacy settings
  bool _recordingEnabled = true;
  bool _transcriptionEnabled = true;
  bool _dataStorageEnabled = true;
  String _dataRetention = '30';

  // Notification settings
  bool _callSummaryNotifications = true;
  bool _spamDetectionNotifications = true;
  String _customRingtone = 'Default';

  // Battery optimization
  bool _batteryOptimized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.activeGreen,
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textSecondary,
          labelStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle:
              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Settings'),
            Tab(text: 'Support'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSettingsTab(),
          _buildSupportTab(),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // Profile Section
          ProfileSectionWidget(
            currentProfile: _currentProfile,
            onProfileChanged: (profile) {
              setState(() {
                _currentProfile = profile;
              });
            },
          ),

          // Call Forwarding Section
          CallForwardingSectionWidget(
            sim1Enabled: _sim1Enabled,
            sim2Enabled: _sim2Enabled,
            onSim1Changed: (enabled) {
              setState(() {
                _sim1Enabled = enabled;
              });
            },
            onSim2Changed: (enabled) {
              setState(() {
                _sim2Enabled = enabled;
              });
            },
            onAdvancedSetup: () {
              _showAdvancedSetupDialog();
            },
          ),

          // Language Preferences
          LanguagePreferencesWidget(
            primaryLanguage: _primaryLanguage,
            aiVoiceLanguage: _aiVoiceLanguage,
            onPrimaryLanguageChanged: (language) {
              setState(() {
                _primaryLanguage = language;
              });
            },
            onAiVoiceLanguageChanged: (language) {
              setState(() {
                _aiVoiceLanguage = language;
              });
            },
          ),

          // Privacy & Security
          PrivacySecurityWidget(
            recordingEnabled: _recordingEnabled,
            transcriptionEnabled: _transcriptionEnabled,
            dataStorageEnabled: _dataStorageEnabled,
            dataRetention: _dataRetention,
            onRecordingChanged: (enabled) {
              setState(() {
                _recordingEnabled = enabled;
              });
            },
            onTranscriptionChanged: (enabled) {
              setState(() {
                _transcriptionEnabled = enabled;
              });
            },
            onDataStorageChanged: (enabled) {
              setState(() {
                _dataStorageEnabled = enabled;
              });
            },
            onDataRetentionChanged: (retention) {
              setState(() {
                _dataRetention = retention;
              });
            },
          ),

          // Contact Management
          SettingsSectionWidget(
            title: 'Contact Management',
            children: [
              SettingsMenuItemWidget(
                title: 'Allowlist',
                subtitle: 'Always answer these contacts',
                iconName: 'check_circle',
                iconColor: AppTheme.activeGreen,
                onTap: () {
                  // Navigate to allowlist screen
                },
              ),
              SettingsMenuItemWidget(
                title: 'Denylist',
                subtitle: 'Block these contacts',
                iconName: 'block',
                iconColor: AppTheme.errorRed,
                onTap: () {
                  // Navigate to denylist screen
                },
              ),
              SettingsMenuItemWidget(
                title: 'Import/Export',
                subtitle: 'Manage contact lists',
                iconName: 'import_export',
                onTap: () {
                  _showImportExportDialog();
                },
              ),
            ],
          ),

          // Notification Settings
          SettingsSectionWidget(
            title: 'Notifications',
            children: [
              SettingsMenuItemWidget(
                title: 'Call Summary Alerts',
                subtitle: 'Get notified after each call',
                iconName: 'notifications',
                trailing: Switch(
                  value: _callSummaryNotifications,
                  onChanged: (value) {
                    setState(() {
                      _callSummaryNotifications = value;
                    });
                  },
                  activeColor: AppTheme.activeGreen,
                ),
                showChevron: false,
              ),
              SettingsMenuItemWidget(
                title: 'Spam Detection',
                subtitle: 'Alerts for potential spam calls',
                iconName: 'security',
                trailing: Switch(
                  value: _spamDetectionNotifications,
                  onChanged: (value) {
                    setState(() {
                      _spamDetectionNotifications = value;
                    });
                  },
                  activeColor: AppTheme.activeGreen,
                ),
                showChevron: false,
              ),
              SettingsMenuItemWidget(
                title: 'Custom Ringtone',
                subtitle: _customRingtone,
                iconName: 'music_note',
                onTap: () {
                  _showRingtoneSelector();
                },
              ),
            ],
          ),

          // Battery Optimization
          SettingsSectionWidget(
            title: 'Battery Optimization',
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: _batteryOptimized
                      ? AppTheme.activeGreen.withValues(alpha: 0.1)
                      : AppTheme.warningAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _batteryOptimized
                        ? AppTheme.activeGreen.withValues(alpha: 0.3)
                        : AppTheme.warningAmber.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName:
                          _batteryOptimized ? 'battery_full' : 'battery_alert',
                      color: _batteryOptimized
                          ? AppTheme.activeGreen
                          : AppTheme.warningAmber,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        _batteryOptimized
                            ? 'Battery optimization is configured correctly'
                            : 'Battery optimization may affect call monitoring',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: _batteryOptimized
                              ? AppTheme.activeGreen
                              : AppTheme.warningAmber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              SettingsMenuItemWidget(
                title: 'Optimize Now',
                subtitle: 'Configure battery settings for best performance',
                iconName: 'tune',
                onTap: () {
                  _optimizeBatterySettings();
                },
              ),
            ],
          ),

          // Advanced Settings
          SettingsSectionWidget(
            title: 'Advanced',
            children: [
              SettingsMenuItemWidget(
                title: 'Safe Word',
                subtitle: 'Emergency termination phrase',
                iconName: 'emergency',
                iconColor: AppTheme.errorRed,
                onTap: () {
                  _showSafeWordDialog();
                },
              ),
              SettingsMenuItemWidget(
                title: 'Backup & Restore',
                subtitle: 'Manage your call data',
                iconName: 'backup',
                onTap: () {
                  _showBackupRestoreDialog();
                },
              ),
              SettingsMenuItemWidget(
                title: 'Diagnostic Tools',
                subtitle: 'Test AI assistant functionality',
                iconName: 'bug_report',
                onTap: () {
                  // Navigate to diagnostic screen
                },
              ),
            ],
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSupportTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // Help & Support
          SettingsSectionWidget(
            title: 'Help & Support',
            children: [
              SettingsMenuItemWidget(
                title: 'FAQ',
                subtitle: 'Frequently asked questions',
                iconName: 'help',
                onTap: () {
                  // Navigate to FAQ screen
                },
              ),
              SettingsMenuItemWidget(
                title: 'Contact Support',
                subtitle: 'Get help from our team',
                iconName: 'support_agent',
                onTap: () {
                  _showContactSupportDialog();
                },
              ),
              SettingsMenuItemWidget(
                title: 'User Guide',
                subtitle: 'Learn how to use the app',
                iconName: 'menu_book',
                onTap: () {
                  // Navigate to user guide
                },
              ),
            ],
          ),

          // About
          SettingsSectionWidget(
            title: 'About',
            children: [
              SettingsMenuItemWidget(
                title: 'App Version',
                subtitle: '1.0.0 (Beta)',
                iconName: 'info',
                showChevron: false,
              ),
              SettingsMenuItemWidget(
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                iconName: 'privacy_tip',
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
              SettingsMenuItemWidget(
                title: 'Terms of Service',
                subtitle: 'App usage terms',
                iconName: 'description',
                onTap: () {
                  // Navigate to terms of service
                },
              ),
            ],
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  void _showAdvancedSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.contentSurface,
        title: Text(
          'Advanced Call Forwarding',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manual GSM Code Configuration:',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            _buildGsmCodeItem('*004*', 'Forward all calls'),
            _buildGsmCodeItem('*67*', 'Forward when busy'),
            _buildGsmCodeItem('*62*', 'Forward when unreachable'),
            _buildGsmCodeItem('*61*', 'Forward when unanswered'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.activeGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGsmCodeItem(String code, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textPrimary,
                fontFamily: 'monospace',
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              description,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImportExportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.contentSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Import/Export Contacts',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'file_upload',
                  color: AppTheme.activeGreen,
                  size: 24,
                ),
                title: Text(
                  'Import from CSV',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle CSV import
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'file_download',
                  color: AppTheme.activeGreen,
                  size: 24,
                ),
                title: Text(
                  'Export to CSV',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle CSV export
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showRingtoneSelector() {
    final ringtones = ['Default', 'Classic', 'Modern', 'Gentle', 'Alert'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.contentSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Ringtone',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ...ringtones.map((ringtone) => ListTile(
                    title: Text(
                      ringtone,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    trailing: _customRingtone == ringtone
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.activeGreen,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _customRingtone = ringtone;
                      });
                      Navigator.pop(context);
                    },
                  )),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _optimizeBatterySettings() {
    setState(() {
      _batteryOptimized = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Battery optimization configured successfully',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.activeGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSafeWordDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.contentSurface,
        title: Text(
          'Configure Safe Word',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set a phrase that will immediately terminate AI assistant and transfer the call to you.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Enter safe word or phrase',
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.borderSubtle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Save safe word
            },
            child: Text(
              'Save',
              style: TextStyle(color: AppTheme.activeGreen),
            ),
          ),
        ],
      ),
    );
  }

  void _showBackupRestoreDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.contentSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Backup & Restore',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'backup',
                  color: AppTheme.activeGreen,
                  size: 24,
                ),
                title: Text(
                  'Create Backup',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Export call data and settings',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle backup creation
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'restore',
                  color: AppTheme.warningAmber,
                  size: 24,
                ),
                title: Text(
                  'Restore from Backup',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Import previously saved data',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle backup restoration
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showContactSupportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.contentSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact Support',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.activeGreen,
                  size: 24,
                ),
                title: Text(
                  'Email Support',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'support@equalai.com',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Open email client
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'chat',
                  color: AppTheme.activeGreen,
                  size: 24,
                ),
                title: Text(
                  'Live Chat',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Available 9 AM - 6 PM IST',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Open live chat
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
