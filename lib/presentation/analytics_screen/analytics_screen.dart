import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/analytics_service.dart';
import './widgets/analytics_card_widget.dart';
import './widgets/call_chart_widget.dart';
import './widgets/recent_calls_list_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsService _analyticsService = AnalyticsService();

  Map<String, dynamic>? _analyticsSummary;
  List<Map<String, dynamic>> _dailyAnalytics = [];
  List<Map<String, dynamic>> _recentCalls = [];

  bool _isLoading = true;
  String? _error;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _analyticsService.getUserAnalyticsSummary(daysBack: _selectedDays),
        _analyticsService.getDailyAnalytics(daysBack: _selectedDays),
        _analyticsService.getCallRecords(limit: 10),
      ]);

      setState(() {
        _analyticsSummary = results[0] as Map<String, dynamic>;
        _dailyAnalytics = results[1] as List<Map<String, dynamic>>;
        _recentCalls = results[2] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Call Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<int>(
            onSelected: (days) {
              setState(() => _selectedDays = days);
              _loadAnalyticsData();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 7, child: Text('Last 7 days')),
              PopupMenuItem(value: 30, child: Text('Last 30 days')),
              PopupMenuItem(value: 90, child: Text('Last 90 days')),
            ],
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Last $_selectedDays days',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 15.w, color: Colors.red),
            SizedBox(height: 2.h),
            Text(
              'Failed to load analytics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 1.h),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _loadAnalyticsData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnalyticsData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildOverviewCards(),
            SizedBox(height: 3.h),

            // Call Chart
            _buildCallChart(),
            SizedBox(height: 3.h),

            // Recent Calls
            _buildRecentCalls(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    if (_analyticsSummary == null) return SizedBox.shrink();

    final summary = _analyticsSummary!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: AnalyticsCardWidget(
                title: 'Total Calls',
                value: '${summary['total_calls'] ?? 0}',
                icon: Icons.call,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: AnalyticsCardWidget(
                title: 'Success Rate',
                value: '${summary['success_rate']?.toStringAsFixed(1) ?? '0'}%',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: AnalyticsCardWidget(
                title: 'Avg Duration',
                value:
                    _formatDuration(summary['average_duration']?.toInt() ?? 0),
                icon: Icons.access_time,
                color: Colors.orange,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: AnalyticsCardWidget(
                title: 'Missed Calls',
                value: '${summary['missed_calls'] ?? 0}',
                icon: Icons.call_missed,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCallChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Call Trends',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 2.h),
        CallChartWidget(dailyData: _dailyAnalytics),
      ],
    );
  }

  Widget _buildRecentCalls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Calls',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.callHistory);
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        RecentCallsListWidget(calls: _recentCalls),
      ],
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}
