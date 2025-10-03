import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String) onChanged;

  const NameInputField({
    Key? key,
    required this.controller,
    this.errorText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What should we call you?',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Your AI assistant will use this name for personalized interactions',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            LengthLimitingTextInputFormatter(30),
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            fillColor: AppTheme.contentSurface,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.activeGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.errorRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.errorRed, width: 2),
            ),
            errorText: errorText,
            errorStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorRed,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  )
                : null,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
        ),
        if (controller.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${controller.text.length}/30',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: controller.text.length > 25
                        ? AppTheme.warningAmber
                        : AppTheme.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
