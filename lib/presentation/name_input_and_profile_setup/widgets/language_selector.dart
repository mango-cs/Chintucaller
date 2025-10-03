import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelector({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> languages = [
      {
        'code': 'English',
        'name': 'English',
        'preview': 'Welcome to Equal AI Assistant'
      },
      {
        'code': 'Hindi',
        'name': 'हिंदी',
        'preview': 'Equal AI असिस्टेंट में आपका स्वागत है'
      },
      {
        'code': 'Telugu',
        'name': 'తెలుగు',
        'preview': 'Equal AI అసిస్టెంట్‌కు స్వాగతం'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Language',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose your preferred language for AI conversations',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.contentSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              dropdownColor: AppTheme.contentSurface,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.textSecondary,
                size: 20,
              ),
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              items: languages.map((language) {
                return DropdownMenuItem<String>(
                  value: language['code'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language['name']!,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        language['preview']!,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 10.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onLanguageChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
