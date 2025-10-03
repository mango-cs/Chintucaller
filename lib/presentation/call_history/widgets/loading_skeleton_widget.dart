import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  const LoadingSkeletonWidget({Key? key}) : super(key: key);

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          itemCount: 8,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.contentSurface,
                borderRadius: BorderRadius.circular(12),
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
                            Container(
                              height: 2.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: AppTheme.borderSubtle
                                    .withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              height: 1.5.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: AppTheme.borderSubtle
                                    .withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              color: AppTheme.borderSubtle
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            height: 1.5.h,
                            width: 12.w,
                            decoration: BoxDecoration(
                              color: AppTheme.borderSubtle
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    height: 1.5.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: AppTheme.borderSubtle
                          .withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 1.5.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: AppTheme.borderSubtle
                          .withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
