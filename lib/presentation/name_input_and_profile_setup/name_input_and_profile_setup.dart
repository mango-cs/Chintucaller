import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_selector.dart';
import './widgets/name_input_field.dart';
import './widgets/profile_type_selector.dart';

class NameInputAndProfileSetup extends StatefulWidget {
  const NameInputAndProfileSetup({Key? key}) : super(key: key);

  @override
  State<NameInputAndProfileSetup> createState() =>
      _NameInputAndProfileSetupState();
}

class _NameInputAndProfileSetupState extends State<NameInputAndProfileSetup> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedProfile = 'Personal';
  String _selectedLanguage = 'English';
  String _selectedGender = 'Male'; // New: Gender selection
  String? _nameError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isEmpty) {
        _nameError = null;
      } else if (_nameController.text.trim().length < 2) {
        _nameError = 'Name must be at least 2 characters';
      } else if (_nameController.text.trim().length > 30) {
        _nameError = 'Name must be less than 30 characters';
      } else {
        _nameError = null;
      }
    });
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _nameController.text.trim().length >= 2 &&
        _nameController.text.trim().length <= 30 &&
        _nameError == null;
  }

  Future<void> _createProfile() async {
    if (!_isFormValid()) {
      setState(() {
        _nameError = _nameController.text.trim().isEmpty
            ? 'Please enter your name'
            : _nameError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate profile creation process
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to voice selection screen (pass name and gender)
      Navigator.pushNamed(
        context,
        '/voice-selection-screen',
        arguments: {
          'name': _nameController.text.trim(),
          'gender': _selectedGender,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),

                    // Main content card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.contentSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name input section
                          NameInputField(
                            controller: _nameController,
                            errorText: _nameError,
                            onChanged: (value) => _validateName(),
                          ),

                          SizedBox(height: 4.h),

                          // Gender selector
                          _buildGenderSelector(),

                          SizedBox(height: 4.h),

                          // Profile type selector
                          ProfileTypeSelector(
                            selectedProfile: _selectedProfile,
                            onProfileChanged: (profile) {
                              setState(() {
                                _selectedProfile = profile;
                              });
                            },
                          ),

                          SizedBox(height: 4.h),

                          // Language selector
                          LanguageSelector(
                            selectedLanguage: _selectedLanguage,
                            onLanguageChanged: (language) {
                              setState(() {
                                _selectedLanguage = language;
                              });
                            },
                          ),

                          SizedBox(height: 4.h),

                          // Privacy note
                          _buildPrivacyNote(),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Bottom button
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.contentSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Profile Setup',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w), // Balance the back button
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Help Your Assistant Know You',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Personalize your AI assistant for better call handling and more natural conversations',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('Male', Icons.male),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildGenderOption('Female', Icons.female),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildGenderOption('Other', Icons.person),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFCDFF00).withValues(alpha: 0.15)
              : AppTheme.primaryBlack.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFFCDFF00) : AppTheme.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFFCDFF00) : AppTheme.textSecondary,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Color(0xFFCDFF00) : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderSubtle.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'security',
            color: AppTheme.activeGreen,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & Security',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.activeGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Your profile data is encrypted and stored locally on your device. We never share your personal information with third parties.',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _createProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isFormValid() ? AppTheme.activeGreen : AppTheme.borderSubtle,
            foregroundColor:
                _isFormValid() ? AppTheme.primaryBlack : AppTheme.textSecondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryBlack,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Profile',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: _isFormValid()
                            ? AppTheme.primaryBlack
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: _isFormValid()
                          ? AppTheme.primaryBlack
                          : AppTheme.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
