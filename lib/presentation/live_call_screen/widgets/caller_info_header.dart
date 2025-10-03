import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CallerInfoHeader extends StatelessWidget {
  final Map<String, dynamic> callerData;
  final String callDuration;

  const CallerInfoHeader({
    Key? key,
    required this.callerData,
    required this.callDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.textPrimary,
                      size: 6.w,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Live Call',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 10.w), // Balance the back button
              ],
            ),
            SizedBox(height: 2.h),
            // Caller avatar
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.activeGreen,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: (callerData['avatar'] as String?)?.isNotEmpty == true
                    ? CustomImageWidget(
                        imageUrl: callerData['avatar'] as String,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppTheme.contentSurface,
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.textSecondary,
                          size: 10.w,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 1.5.h),
            // Caller name
            Text(
              (callerData['name'] as String?) ?? 'Unknown Caller',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            // Phone number
            Text(
              (callerData['phoneNumber'] as String?) ?? '+91 XXXXXXXXXX',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            // Call duration
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.contentSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.activeGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    callDuration,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
