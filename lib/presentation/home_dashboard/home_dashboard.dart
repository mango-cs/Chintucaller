import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dev_navigation_drawer.dart';
import './widgets/dual_sim_widget.dart';
import './widgets/emergency_override_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_calls_widget.dart';
import './widgets/statistics_card_widget.dart';
import './widgets/status_card_widget.dart';
import 'package:flutter/material.dart' as material;

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  List<NavigationDestination> get _destinations => [
        NavigationDestination(
          icon: Icon(Icons.home_outlined,
              color:
                  _selectedIndex == 0 ? Color(0xFFCDFF00) : Colors.grey[600]),
          selectedIcon: Icon(Icons.home, color: Color(0xFFCDFF00)),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.call_outlined,
              color:
                  _selectedIndex == 1 ? Color(0xFFCDFF00) : Colors.grey[600]),
          selectedIcon: Icon(Icons.call, color: Color(0xFFCDFF00)),
          label: 'Calls',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined,
              color:
                  _selectedIndex == 2 ? Color(0xFFCDFF00) : Colors.grey[600]),
          selectedIcon: Icon(Icons.analytics, color: Color(0xFFCDFF00)),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined,
              color:
                  _selectedIndex == 3 ? Color(0xFFCDFF00) : Colors.grey[600]),
          selectedIcon: Icon(Icons.settings, color: Color(0xFFCDFF00)),
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
      drawer: const DevNavigationDrawer(), // DEV ONLY: Remove before production
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.construction, color: Colors.orange),
            tooltip: 'DEV: All Screens',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
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
            itemBuilder: (context) => [
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
              onViewAllCalls: () =>
                  Navigator.pushNamed(context, '/call-history'),
              onChangeProfile: () => Navigator.pushNamed(context, '/profiles'),
              onAssistantSettings: () =>
                  Navigator.pushNamed(context, AppRoutes.settings),
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

            // Bottom padding for NavigationBar and FAB
            SizedBox(height: 2.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: Colors.grey[900]!,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          backgroundColor: Colors.black,
          indicatorColor: Color(0xFFCDFF00).withValues(alpha: 0.15),
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          height: 8.h,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _destinations,
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFCDFF00).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.liveCall);
          },
          backgroundColor: Color(0xFFCDFF00),
          elevation: 0,
          child: Icon(Icons.call, color: Colors.black, size: 7.w),
        ),
      ),
    );
  }
}
