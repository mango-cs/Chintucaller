import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecentCallsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> calls;

  const RecentCallsListWidget({
    super.key,
    required this.calls,
  });

  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: calls.length > 5 ? 5 : calls.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final call = calls[index];
          return _buildCallItem(context, call);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.call_outlined,
              size: 12.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 2.h),
            Text(
              'No recent calls',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your recent call activity will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallItem(BuildContext context, Map<String, dynamic> call) {
    final callerName = call['caller_name'] ?? 'Unknown';
    final callerPhone = call['caller_phone'] ?? '';
    final callStatus = call['call_status'] ?? 'unknown';
    final startTime = call['start_time'] != null
        ? DateTime.tryParse(call['start_time'])
        : null;
    final duration = call['duration'];
    final aiConfidence = call['ai_confidence_score'];

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: _buildCallStatusIcon(callStatus),
      title: Text(
        callerName,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            callerPhone,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          if (duration != null) ...[
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 3.w,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 1.w),
                Text(
                  _formatDuration(duration),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
                if (aiConfidence != null) ...[
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.psychology,
                    size: 3.w,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${(aiConfidence * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
      trailing: startTime != null
          ? Text(
              _formatTime(startTime),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            )
          : null,
    );
  }

  Widget _buildCallStatusIcon(String status) {
    IconData iconData;
    Color color;

    switch (status) {
      case 'completed':
      case 'answered':
        iconData = Icons.call_received;
        color = Colors.green;
        break;
      case 'missed':
        iconData = Icons.call_missed;
        color = Colors.red;
        break;
      case 'in_progress':
        iconData = Icons.call;
        color = Colors.orange;
        break;
      case 'outgoing':
        iconData = Icons.call_made;
        color = Colors.blue;
        break;
      case 'failed':
        iconData = Icons.call_end;
        color = Colors.red;
        break;
      default:
        iconData = Icons.call;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: color,
        size: 5.w,
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
