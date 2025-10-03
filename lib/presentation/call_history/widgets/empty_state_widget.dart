import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String type;
  final VoidCallback? onRefresh;

  const EmptyStateWidget({
    Key? key,
    required this.type,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    String iconName;

    switch (type) {
      case 'no_results':
        title = 'No Results Found';
        subtitle =
            'Try adjusting your search terms or filters to find what you\'re looking for.';
        iconName = 'search_off';
        break;
      case 'first_time':
        title = 'No Call History Yet';
        subtitle =
            'Your AI assistant will start handling calls once activated. All call summaries will appear here.';
        iconName = 'phone_disabled';
        break;
      case 'no_calls_today':
        title = 'No Calls Today';
        subtitle =
            'You haven\'t received any calls today. Check back later or view all history.';
        iconName = 'today';
        break;
      case 'no_spam':
        title = 'No Spam Calls';
        subtitle =
            'Great! Your AI assistant hasn\'t detected any spam calls recently.';
        iconName = 'verified_user';
        break;
      default:
        title = 'No Calls Found';
        subtitle = 'There are no calls matching your current filter.';
        iconName = 'phone_disabled';
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.contentSurface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.textSecondary,
                size: 10.w,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRefresh != null) ...[
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.primaryBlack,
                size: 18,
              ),
              label: Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.activeGreen,
                foregroundColor: AppTheme.primaryBlack,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
