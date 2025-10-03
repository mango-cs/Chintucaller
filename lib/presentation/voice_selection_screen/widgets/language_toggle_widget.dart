import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class LanguageToggleWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageToggleWidget({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = ['English', 'Hindi', 'Telugu'];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'language',
                color: AppTheme.activeGreen,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Preview Language',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose language for voice preview',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: languages.map((language) {
                final isSelected = selectedLanguage == language;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onLanguageChanged(language),
                    child: Container(
                      margin: EdgeInsets.all(0.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.activeGreen
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          language,
                          style:
                              AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                            color: isSelected
                                ? AppTheme.primaryBlack
                                : AppTheme.textSecondary,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
