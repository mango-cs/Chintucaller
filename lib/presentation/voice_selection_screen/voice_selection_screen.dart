import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';

class VoiceSelectionScreen extends StatefulWidget {
  const VoiceSelectionScreen({Key? key}) : super(key: key);

  @override
  State<VoiceSelectionScreen> createState() => _VoiceSelectionScreenState();
}

class _VoiceSelectionScreenState extends State<VoiceSelectionScreen> {
  String _selectedVoice = 'male';
  bool _isPlayingPreview = false;
  String? _userName;
  String? _userGender;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _userName = args['name'] as String?;
      _userGender = args['gender'] as String?;
      if (_userGender != null) {
        setState(() {
          _selectedVoice =
              _userGender!.toLowerCase() == 'male' ? 'male' : 'female';
        });
      }
    }
  }

  void _playPreview() async {
    if (_isPlayingPreview) return;

    setState(() => _isPlayingPreview = true);
    HapticFeedback.mediumImpact();

    await Future.delayed(Duration(seconds: 3));

    if (mounted) {
      setState(() => _isPlayingPreview = false);
    }
  }

  void _handleContinue() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, AppRoutes.permissionRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: 4.h),

              // Progress indicator
              _buildProgressIndicator(),

              SizedBox(height: 6.h),

              // Title
              Text(
                'Select Assistant Voice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              // Subtitle
              Text(
                'How would you like your assistant to sound?',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              // Voice selection area - side by side
              Expanded(
                child: Row(
                  children: [
                    // Male Voice
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedVoice = 'male');
                          HapticFeedback.selectionClick();
                        },
                        child: _buildVoiceCard(
                          gender: 'male',
                          icon: '👨',
                          isSelected: _selectedVoice == 'male',
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Female Voice
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedVoice = 'female');
                          HapticFeedback.selectionClick();
                        },
                        child: _buildVoiceCard(
                          gender: 'female',
                          icon: '👩',
                          isSelected: _selectedVoice == 'female',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Preview card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Waveform animation
                    if (_isPlayingPreview)
                      _buildWaveform()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 1.5.w,
                            height: 4.h,
                            margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                            decoration: BoxDecoration(
                              color: Color(0xFFCDFF00),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),

                    SizedBox(height: 2.h),

                    // Preview text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 16.sp),
                        children: [
                          TextSpan(
                            text: 'Hi ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: _userName ?? 'there',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          TextSpan(
                            text: '!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'This is your Equal AI Assistant.',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 3.h),

                    // Play button
                    GestureDetector(
                      onTap: _playPreview,
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlayingPreview ? Icons.stop : Icons.play_arrow,
                          color: Colors.black,
                          size: 8.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h), // Spacer to push button to bottom

              // Proceed button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCDFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(4, (index) {
        final isCompleted = index < 3; // Steps 1, 2, 3 completed
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: isCompleted ? Color(0xFFCDFF00) : Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVoiceCard({
    required String gender,
    required String icon,
    required bool isSelected,
  }) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Color(0xFFCDFF00) : Colors.transparent,
          width: 0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar/Icon
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Color(0xFFCDFF00), width: 3)
                  : null,
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(fontSize: 60.sp),
              ),
            ),
          ),

          if (isSelected) ...[
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: Color(0xFFCDFF00),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 5.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 1.5.w,
          height: (6 + (index % 2) * 2).h,
          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
          decoration: BoxDecoration(
            color: Color(0xFFCDFF00),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
