import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/call_history_card.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/search_bar_widget.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _selectedFilter = 'all';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  List<Map<String, dynamic>> _allCalls = [];
  List<Map<String, dynamic>> _filteredCalls = [];
  Set<int> _selectedCallIds = {};
  bool _isSelectionMode = false;

  // Mock data for call history
  final List<Map<String, dynamic>> _mockCallData = [
    {
      "id": 1,
      "callerName": "Zomato Delivery",
      "phoneNumber": "+91 98765 43210",
      "timestamp": "2 hours ago",
      "duration": "1:23",
      "summary":
          "Delivery executive called to confirm your order location. Order #ZOM123456 will be delivered in 15 minutes.",
      "outcome": "handled",
      "isSpam": false,
      "hasOtp": false,
      "category": "delivery",
      "date": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 2,
      "callerName": "HDFC Bank",
      "phoneNumber": "+91 87654 32109",
      "timestamp": "5 hours ago",
      "duration": "2:45",
      "summary":
          "Credit card payment reminder for \$2,500. Due date is tomorrow. OTP: 456789 for verification.",
      "outcome": "transferred",
      "isSpam": false,
      "hasOtp": true,
      "category": "important",
      "date": DateTime.now().subtract(Duration(hours: 5)),
    },
    {
      "id": 3,
      "callerName": "Unknown Caller",
      "phoneNumber": "+91 76543 21098",
      "timestamp": "Yesterday",
      "duration": "0:45",
      "summary":
          "Promotional call about insurance policies. Caller was persistent despite declining interest.",
      "outcome": "spam",
      "isSpam": true,
      "hasOtp": false,
      "category": "spam",
      "date": DateTime.now().subtract(Duration(days: 1)),
    },
    {
      "id": 4,
      "callerName": "Dr. Sharma's Clinic",
      "phoneNumber": "+91 65432 10987",
      "timestamp": "Yesterday",
      "duration": "3:12",
      "summary":
          "Appointment confirmation for tomorrow at 3 PM. Please bring your medical reports and ID.",
      "outcome": "handled",
      "isSpam": false,
      "hasOtp": false,
      "category": "important",
      "date": DateTime.now().subtract(Duration(days: 1)),
    },
    {
      "id": 5,
      "callerName": "Amazon Delivery",
      "phoneNumber": "+91 54321 09876",
      "timestamp": "2 days ago",
      "duration": "1:56",
      "summary":
          "Package delivery scheduled for today between 10 AM - 2 PM. Order #AMZ789012 contains 2 items.",
      "outcome": "handled",
      "isSpam": false,
      "hasOtp": false,
      "category": "delivery",
      "date": DateTime.now().subtract(Duration(days: 2)),
    },
    {
      "id": 6,
      "callerName": "Marketing Call",
      "phoneNumber": "+91 43210 98765",
      "timestamp": "3 days ago",
      "duration": "0:30",
      "summary":
          "Unsolicited marketing call about loan offers. Call was automatically terminated.",
      "outcome": "spam",
      "isSpam": true,
      "hasOtp": false,
      "category": "spam",
      "date": DateTime.now().subtract(Duration(days: 3)),
    },
    {
      "id": 7,
      "callerName": "Swiggy Support",
      "phoneNumber": "+91 32109 87654",
      "timestamp": "3 days ago",
      "duration": "4:23",
      "summary":
          "Order refund processed for cancelled order. Amount \$450 will be credited within 3-5 business days.",
      "outcome": "handled",
      "isSpam": false,
      "hasOtp": false,
      "category": "delivery",
      "date": DateTime.now().subtract(Duration(days: 3)),
    },
    {
      "id": 8,
      "callerName": "Unknown Number",
      "phoneNumber": "+91 21098 76543",
      "timestamp": "1 week ago",
      "duration": "0:15",
      "summary": "Call disconnected immediately. Likely spam or wrong number.",
      "outcome": "incomplete",
      "isSpam": false,
      "hasOtp": false,
      "category": "missed",
      "date": DateTime.now().subtract(Duration(days: 7)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _scrollController.addListener(_onScroll);
    _loadCallHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreCalls();
    }
  }

  Future<void> _loadCallHistory() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _allCalls = List.from(_mockCallData);
      _filteredCalls = List.from(_allCalls);
      _isLoading = false;
    });
  }

  Future<void> _loadMoreCalls() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more calls
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshCalls() async {
    await _loadCallHistory();
    Fluttertoast.showToast(
      msg: "Call history refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.activeGreen,
      textColor: AppTheme.primaryBlack,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allCalls);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((call) {
        final callerName = (call['callerName'] as String).toLowerCase();
        final phoneNumber = (call['phoneNumber'] as String).toLowerCase();
        final summary = (call['summary'] as String).toLowerCase();

        return callerName.contains(_searchQuery) ||
            phoneNumber.contains(_searchQuery) ||
            summary.contains(_searchQuery);
      }).toList();
    }

    // Apply category filter
    if (_selectedFilter != 'all') {
      switch (_selectedFilter) {
        case 'today':
          filtered = filtered.where((call) {
            final callDate = call['date'] as DateTime;
            final now = DateTime.now();
            return callDate.year == now.year &&
                callDate.month == now.month &&
                callDate.day == now.day;
          }).toList();
          break;
        case 'week':
          filtered = filtered.where((call) {
            final callDate = call['date'] as DateTime;
            final weekAgo = DateTime.now().subtract(Duration(days: 7));
            return callDate.isAfter(weekAgo);
          }).toList();
          break;
        case 'missed':
          filtered = filtered
              .where((call) =>
                  call['category'] == 'missed' ||
                  call['outcome'] == 'incomplete')
              .toList();
          break;
        case 'spam':
          filtered = filtered.where((call) => call['isSpam'] == true).toList();
          break;
        case 'important':
          filtered = filtered
              .where((call) => call['category'] == 'important')
              .toList();
          break;
      }
    }

    setState(() {
      _filteredCalls = filtered;
    });
  }

  Map<String, int> _getFilterCounts() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));

    return {
      'all': _allCalls.length,
      'today': _allCalls.where((call) {
        final callDate = call['date'] as DateTime;
        return callDate.year == now.year &&
            callDate.month == now.month &&
            callDate.day == now.day;
      }).length,
      'week': _allCalls.where((call) {
        final callDate = call['date'] as DateTime;
        return callDate.isAfter(weekAgo);
      }).length,
      'missed': _allCalls
          .where((call) =>
              call['category'] == 'missed' || call['outcome'] == 'incomplete')
          .length,
      'spam': _allCalls.where((call) => call['isSpam'] == true).length,
      'important':
          _allCalls.where((call) => call['category'] == 'important').length,
    };
  }

  void _onCallTap(Map<String, dynamic> callData) {
    if (_isSelectionMode) {
      _toggleCallSelection(callData['id']);
    } else {
      // Navigate to call details (would be implemented)
      Fluttertoast.showToast(
        msg: "Opening call details for ${callData['callerName']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _onCallLongPress(Map<String, dynamic> callData) {
    setState(() {
      _isSelectionMode = true;
      _selectedCallIds.add(callData['id']);
    });
  }

  void _toggleCallSelection(int callId) {
    setState(() {
      if (_selectedCallIds.contains(callId)) {
        _selectedCallIds.remove(callId);
        if (_selectedCallIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedCallIds.add(callId);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedCallIds.clear();
    });
  }

  void _onCallBack(Map<String, dynamic> callData) {
    Fluttertoast.showToast(
      msg: "Calling ${callData['callerName']}...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.activeGreen,
      textColor: AppTheme.primaryBlack,
    );
  }

  void _onCopyOtp(Map<String, dynamic> callData) {
    Fluttertoast.showToast(
      msg: "OTP copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.warningAmber,
      textColor: AppTheme.primaryBlack,
    );
  }

  void _onAddContact(Map<String, dynamic> callData) {
    Fluttertoast.showToast(
      msg: "Adding ${callData['callerName']} to contacts",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successTeal,
      textColor: AppTheme.primaryBlack,
    );
  }

  void _onMarkSpam(Map<String, dynamic> callData) {
    setState(() {
      final index =
          _allCalls.indexWhere((call) => call['id'] == callData['id']);
      if (index != -1) {
        _allCalls[index]['isSpam'] = true;
        _allCalls[index]['outcome'] = 'spam';
        _applyFilters();
      }
    });

    Fluttertoast.showToast(
      msg: "Marked ${callData['callerName']} as spam",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.errorRed,
      textColor: AppTheme.textPrimary,
    );
  }

  void _onDeleteCall(Map<String, dynamic> callData) {
    setState(() {
      _allCalls.removeWhere((call) => call['id'] == callData['id']);
      _applyFilters();
    });

    Fluttertoast.showToast(
      msg: "Call deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onShareCall(Map<String, dynamic> callData) {
    Fluttertoast.showToast(
      msg: "Sharing call summary",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoading) {
      return LoadingSkeletonWidget();
    }

    if (_filteredCalls.isEmpty) {
      String emptyType = 'no_results';
      if (_searchQuery.isEmpty) {
        if (_selectedFilter == 'today') {
          emptyType = 'no_calls_today';
        } else if (_selectedFilter == 'spam') {
          emptyType = 'no_spam';
        } else if (_allCalls.isEmpty) {
          emptyType = 'first_time';
        }
      }

      return EmptyStateWidget(
        type: emptyType,
        onRefresh: _refreshCalls,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCalls,
      color: AppTheme.activeGreen,
      backgroundColor: AppTheme.contentSurface,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: _filteredCalls.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _filteredCalls.length) {
            return Container(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.activeGreen,
                ),
              ),
            );
          }

          final callData = _filteredCalls[index];
          final isSelected = _selectedCallIds.contains(callData['id']);

          return GestureDetector(
            onLongPress: () => _onCallLongPress(callData),
            child: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      color: AppTheme.activeGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: CallHistoryCard(
                callData: callData,
                onTap: () => _onCallTap(callData),
                onCallBack: () => _onCallBack(callData),
                onCopyOtp:
                    callData['hasOtp'] ? () => _onCopyOtp(callData) : null,
                onAddContact: () => _onAddContact(callData),
                onMarkSpam: () => _onMarkSpam(callData),
                onDelete: () => _onDeleteCall(callData),
                onShare: () => _onShareCall(callData),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme.textSecondary,
            size: 15.w,
          ),
          SizedBox(height: 4.h),
          Text(
            'Analytics Coming Soon',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Detailed call analytics and insights will be available here.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _exitSelectionMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
              ),
        title: _isSelectionMode
            ? Text(
                '${_selectedCallIds.length} selected',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              )
            : Text(
                'Call History',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
        actions: _isSelectionMode
            ? [
                IconButton(
                  onPressed: () {
                    // Bulk delete action
                    setState(() {
                      _allCalls.removeWhere(
                          (call) => _selectedCallIds.contains(call['id']));
                      _applyFilters();
                      _exitSelectionMode();
                    });
                    Fluttertoast.showToast(
                      msg: "Selected calls deleted",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.errorRed,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Bulk mark spam action
                    setState(() {
                      for (int id in _selectedCallIds) {
                        final index =
                            _allCalls.indexWhere((call) => call['id'] == id);
                        if (index != -1) {
                          _allCalls[index]['isSpam'] = true;
                          _allCalls[index]['outcome'] = 'spam';
                        }
                      }
                      _applyFilters();
                      _exitSelectionMode();
                    });
                    Fluttertoast.showToast(
                      msg: "Selected calls marked as spam",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'block',
                    color: AppTheme.errorRed,
                    size: 24,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    // Search functionality
                    Fluttertoast.showToast(
                      msg: "Search functionality",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.textPrimary,
                    size: 24,
                  ),
                ),
              ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.activeGreen,
          indicatorWeight: 3,
          labelStyle: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle:
              AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          tabs: [
            Tab(text: 'History'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (!_isSelectionMode) ...[
            SearchBarWidget(
              onSearchChanged: _onSearchChanged,
              onClearSearch: () {
                setState(() {
                  _searchQuery = '';
                  _applyFilters();
                });
              },
            ),
            FilterChipsWidget(
              selectedFilter: _selectedFilter,
              onFilterSelected: _onFilterSelected,
              filterCounts: _getFilterCounts(),
            ),
            SizedBox(height: 1.h),
          ],
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHistoryTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
