import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguagePreferencesWidget extends StatelessWidget {
  final String primaryLanguage;
  final String aiVoiceLanguage;
  final Function(String) onPrimaryLanguageChanged;
  final Function(String) onAiVoiceLanguageChanged;

  const LanguagePreferencesWidget({
    Key? key,
    required this.primaryLanguage,
    required this.aiVoiceLanguage,
    required this.onPrimaryLanguageChanged,
    required this.onAiVoiceLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language Preferences',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildLanguageSelector(
            'App Language',
            'Interface and text display',
            primaryLanguage,
            onPrimaryLanguageChanged,
            'translate',
          ),
          SizedBox(height: 2.h),
          _buildLanguageSelector(
            'AI Voice Language',
            'Language for AI conversations',
            aiVoiceLanguage,
            onAiVoiceLanguageChanged,
            'record_voice_over',
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.activeGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.activeGreen.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'auto_awesome',
                  color: AppTheme.activeGreen,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'AI automatically detects caller language and responds accordingly',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.activeGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    String title,
    String subtitle,
    String currentLanguage,
    Function(String) onChanged,
    String iconName,
  ) {
    return GestureDetector(
      onTap: () => _showLanguageSelector(title, currentLanguage, onChanged),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                currentLanguage,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(
      String title, String currentLanguage, Function(String) onChanged) {
    // This would show a language selection dialog
    // For now, we'll just cycle through available languages
    final languages = ['English', 'Hindi', 'Telugu'];
    final currentIndex = languages.indexOf(currentLanguage);
    final nextIndex = (currentIndex + 1) % languages.length;
    onChanged(languages[nextIndex]);
  }
}
