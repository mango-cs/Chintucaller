import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentCallsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentCalls;
  final Function(Map<String, dynamic>) onCallBack;
  final Function(Map<String, dynamic>) onMarkSpam;
  final Function(Map<String, dynamic>) onViewSummary;
  final Function(Map<String, dynamic>) onAddContact;

  const RecentCallsWidget({
    Key? key,
    required this.recentCalls,
    required this.onCallBack,
    required this.onMarkSpam,
    required this.onViewSummary,
    required this.onAddContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'call',
                    color: AppTheme.textPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Recent AI Calls',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/call-history'),
                child: Text(
                  'View All',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.activeGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          recentCalls.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: recentCalls.asMap().entries.map((entry) {
                    final index = entry.key;
                    final call = entry.value;
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: index < recentCalls.length - 1 ? 2.h : 0),
                      child: _buildCallCard(call),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'call_received',
            color: AppTheme.textSecondary,
            size: 40,
          ),
          SizedBox(height: 2.h),
          Text(
            'No recent AI calls',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your AI assistant will handle calls automatically',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCallCard(Map<String, dynamic> call) {
    final String callerName = call['callerName'] as String? ?? 'Unknown';
    final String callerNumber = call['callerNumber'] as String? ?? '';
    final DateTime timestamp = call['timestamp'] as DateTime? ?? DateTime.now();
    final String outcome = call['outcome'] as String? ?? 'completed';
    final String intent = call['intent'] as String? ?? 'unknown';
    final String duration = call['duration'] as String? ?? '0:00';

    return Slidable(
      key: ValueKey(call['id']),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onCallBack(call),
            backgroundColor: AppTheme.activeGreen,
            foregroundColor: AppTheme.primaryBlack,
            icon: Icons.call,
            label: 'Call Back',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onMarkSpam(call),
            backgroundColor: AppTheme.errorRed,
            foregroundColor: AppTheme.textPrimary,
            icon: Icons.block,
            label: 'Mark Spam',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onViewSummary(call),
            backgroundColor: AppTheme.warningAmber,
            foregroundColor: AppTheme.primaryBlack,
            icon: Icons.summarize,
            label: 'Summary',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onAddContact(call),
            backgroundColor: AppTheme.successTeal,
            foregroundColor: AppTheme.primaryBlack,
            icon: Icons.person_add,
            label: 'Add Contact',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _getOutcomeColor(outcome).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getOutcomeIcon(outcome),
                  color: _getOutcomeColor(outcome),
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    callerName,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (callerNumber.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      callerNumber,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getIntentColor(intent).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getIntentLabel(intent),
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: _getIntentColor(intent),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        duration,
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimestamp(timestamp),
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 1.h),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getOutcomeColor(String outcome) {
    switch (outcome.toLowerCase()) {
      case 'completed':
        return AppTheme.activeGreen;
      case 'missed':
        return AppTheme.errorRed;
      case 'spam':
        return AppTheme.errorRed;
      case 'transferred':
        return AppTheme.warningAmber;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getOutcomeIcon(String outcome) {
    switch (outcome.toLowerCase()) {
      case 'completed':
        return 'call_received';
      case 'missed':
        return 'call_missed';
      case 'spam':
        return 'block';
      case 'transferred':
        return 'call_made';
      default:
        return 'call';
    }
  }

  Color _getIntentColor(String intent) {
    switch (intent.toLowerCase()) {
      case 'delivery':
        return AppTheme.successTeal;
      case 'marketing':
        return AppTheme.warningAmber;
      case 'personal':
        return AppTheme.activeGreen;
      case 'work':
        return AppTheme.activeGreen;
      case 'spam':
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getIntentLabel(String intent) {
    switch (intent.toLowerCase()) {
      case 'delivery':
        return 'Delivery';
      case 'marketing':
        return 'Marketing';
      case 'personal':
        return 'Personal';
      case 'work':
        return 'Work';
      case 'spam':
        return 'Spam';
      default:
        return 'Unknown';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
