import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallHistoryCard extends StatelessWidget {
  final Map<String, dynamic> callData;
  final VoidCallback? onTap;
  final VoidCallback? onCallBack;
  final VoidCallback? onCopyOtp;
  final VoidCallback? onAddContact;
  final VoidCallback? onMarkSpam;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const CallHistoryCard({
    Key? key,
    required this.callData,
    this.onTap,
    this.onCallBack,
    this.onCopyOtp,
    this.onAddContact,
    this.onMarkSpam,
    this.onDelete,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String callerName = callData['callerName'] ?? 'Unknown';
    final String phoneNumber = callData['phoneNumber'] ?? '';
    final String timestamp = callData['timestamp'] ?? '';
    final String duration = callData['duration'] ?? '';
    final String summary = callData['summary'] ?? '';
    final String outcome = callData['outcome'] ?? 'handled';
    final bool isSpam = callData['isSpam'] ?? false;
    final bool hasOtp = callData['hasOtp'] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(callData['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onCallBack?.call(),
              backgroundColor: AppTheme.activeGreen,
              foregroundColor: AppTheme.primaryBlack,
              icon: Icons.phone,
              label: 'Call Back',
              borderRadius: BorderRadius.circular(12),
            ),
            if (hasOtp)
              SlidableAction(
                onPressed: (_) => onCopyOtp?.call(),
                backgroundColor: AppTheme.warningAmber,
                foregroundColor: AppTheme.primaryBlack,
                icon: Icons.copy,
                label: 'Copy OTP',
                borderRadius: BorderRadius.circular(12),
              ),
            SlidableAction(
              onPressed: (_) => onAddContact?.call(),
              backgroundColor: AppTheme.successTeal,
              foregroundColor: AppTheme.primaryBlack,
              icon: Icons.person_add,
              label: 'Add Contact',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onMarkSpam?.call(),
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.block,
              label: 'Mark Spam',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: AppTheme.textSecondary,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: AppTheme.activeGreen,
              foregroundColor: AppTheme.primaryBlack,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.contentSurface,
              borderRadius: BorderRadius.circular(12),
              border: isSpam
                  ? Border.all(color: AppTheme.errorRed, width: 1)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  callerName,
                                  style: AppTheme
                                      .darkTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: isSpam
                                        ? AppTheme.errorRed
                                        : AppTheme.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildOutcomeIcon(outcome),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            phoneNumber,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timestamp,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          duration,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  summary,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (hasOtp) ...[
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.warningAmber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'security',
                          color: AppTheme.warningAmber,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'OTP Detected',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.warningAmber,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutcomeIcon(String outcome) {
    IconData iconData;
    Color iconColor;

    switch (outcome) {
      case 'handled':
        iconData = Icons.check_circle;
        iconColor = AppTheme.activeGreen;
        break;
      case 'transferred':
        iconData = Icons.call_made;
        iconColor = AppTheme.successTeal;
        break;
      case 'spam':
        iconData = Icons.block;
        iconColor = AppTheme.errorRed;
        break;
      case 'incomplete':
        iconData = Icons.warning;
        iconColor = AppTheme.warningAmber;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = AppTheme.textSecondary;
    }

    return CustomIconWidget(
      iconName: iconData.codePoint.toString(),
      color: iconColor,
      size: 20,
    );
  }
}
