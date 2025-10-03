import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import './widgets/dual_sim_widget.dart';
import './widgets/emergency_override_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_calls_widget.dart';
import './widgets/statistics_card_widget.dart';
import './widgets/status_card_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.call_outlined),
      selectedIcon: Icon(Icons.call),
      label: 'Calls',
    ),
    const NavigationDestination(
      icon: Icon(Icons.analytics_outlined),
      selectedIcon: Icon(Icons.analytics),
      label: 'Analytics',
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/call-history');
        break;
      case 2:
        Navigator.pushNamed(context, '/analytics');
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: Text(
          'AI Call Assistant',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        actions: [
          // Analytics Button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/analytics'),
            icon: Icon(Icons.analytics_outlined, color: AppTheme.textPrimary),
            tooltip: 'Analytics',
          ),

          // Profile Menu
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case 'analytics':
                  Navigator.pushNamed(context, '/analytics');
                  break;
                case 'settings':
                  Navigator.pushNamed(context, AppRoutes.settings);
                  break;
                case 'logout':
                  await _authService.signOut();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'analytics',
                    child: Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          size: 5.w,
                          color: AppTheme.textPrimary,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Analytics',
                          style: TextStyle(color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 5.w,
                          color: AppTheme.textPrimary,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Settings',
                          style: TextStyle(color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 5.w, color: Colors.red),
                        SizedBox(width: 2.w),
                        Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
            color: AppTheme.contentSurface,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Icon(Icons.more_vert, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Status Card showing AI Assistant status
            StatusCardWidget(
              isAssistantActive: true,
              currentProfile: 'Default',
              onToggleAssistant: () {},
              onChangeProfile: () {},
            ),
            SizedBox(height: 3.h),

            // Dual SIM Management
            DualSimWidget(
              simData: [
                {
                  'forwardingActive': true,
                  'carrierName': 'Carrier 1',
                  'simNumber': 'SIM 1',
                  'signalStrength': 85,
                },
                {
                  'forwardingActive': false,
                  'carrierName': 'Carrier 2',
                  'simNumber': 'SIM 2',
                  'signalStrength': 70,
                },
              ],
            ),
            SizedBox(height: 3.h),

            // Statistics Cards Row
            StatisticsCardWidget(
              statistics: {
                'todayCalls': 5,
                'weekCalls': 23,
                'spamBlocked': 8,
                'efficiency': 85.0,
              },
            ),
            SizedBox(height: 3.h),

            // Quick Actions
            QuickActionsWidget(
              onViewAllCalls:
                  () => Navigator.pushNamed(context, '/call-history'),
              onChangeProfile: () => Navigator.pushNamed(context, '/profiles'),
              onAssistantSettings:
                  () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
            SizedBox(height: 3.h),

            // Recent Calls
            RecentCallsWidget(
              recentCalls: [],
              onCallBack: (call) {},
              onMarkSpam: (call) {},
              onViewSummary: (call) {},
              onAddContact: (call) {},
            ),
            SizedBox(height: 3.h),

            // Emergency Override
            EmergencyOverrideWidget(
              isOverrideActive: false,
              onToggleOverride: () {},
            ),

            // Bottom padding for NavigationBar
            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: AppTheme.contentSurface,
        indicatorColor: AppTheme.activeGreen.withValues(alpha: 0.2),
        destinations:
            _destinations
                .map(
                  (destination) => NavigationDestination(
                    icon: destination.icon,
                    selectedIcon: destination.selectedIcon,
                    label: destination.label,
                  ),
                )
                .toList(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.liveCall);
        },
        backgroundColor: AppTheme.activeGreen,
        child: Icon(Icons.call, color: AppTheme.primaryBlack),
      ),
    );
  }
}
