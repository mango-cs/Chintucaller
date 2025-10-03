import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final Map<String, int> filterCounts;

  const FilterChipsWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.filterCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filters = [
      {'key': 'all', 'label': 'All', 'icon': 'list'},
      {'key': 'today', 'label': 'Today', 'icon': 'today'},
      {'key': 'week', 'label': 'This Week', 'icon': 'date_range'},
      {'key': 'missed', 'label': 'Missed', 'icon': 'phone_missed'},
      {'key': 'spam', 'label': 'Spam', 'icon': 'block'},
      {'key': 'important', 'label': 'Important', 'icon': 'star'},
    ];

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final String filterKey = filter['key'];
          final String label = filter['label'];
          final String icon = filter['icon'];
          final bool isSelected = selectedFilter == filterKey;
          final int count = filterCounts[filterKey] ?? 0;

          return GestureDetector(
            onTap: () => onFilterSelected(filterKey),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppTheme.activeGreen : AppTheme.contentSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.activeGreen : AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: icon,
                    color: isSelected
                        ? AppTheme.primaryBlack
                        : AppTheme.textSecondary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    label,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryBlack
                          : AppTheme.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (count > 0 && filterKey != 'all') ...[
                    SizedBox(width: 1.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.2.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlack.withValues(alpha: 0.2)
                            : AppTheme.activeGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryBlack
                              : AppTheme.primaryBlack,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
