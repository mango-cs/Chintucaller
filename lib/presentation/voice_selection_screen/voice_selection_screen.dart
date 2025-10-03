import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/audio_waveform_widget.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/voice_option_card.dart';
import './widgets/volume_slider_widget.dart';

class VoiceSelectionScreen extends StatefulWidget {
  const VoiceSelectionScreen({Key? key}) : super(key: key);

  @override
  State<VoiceSelectionScreen> createState() => _VoiceSelectionScreenState();
}

class _VoiceSelectionScreenState extends State<VoiceSelectionScreen> {
  String? _selectedVoice;
  String _selectedLanguage = 'English';
  double _volume = 0.7;
  bool _isPlaying = false;
  String? _currentPlayingVoice;
  bool _hasPreviewedSelected = false;
  Timer? _playbackTimer;
  Duration _playbackDuration = Duration(seconds: 10);
  Duration _playbackPosition = Duration.zero;

  final List<Map<String, dynamic>> _voiceOptions = [
    {
      "id": "male_voice_1",
      "type": "Male",
      "name": "Arjun",
      "description":
          "Professional and warm tone, perfect for business calls and formal conversations",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "sampleText": {
        "English":
            "Hello, this is your AI assistant speaking. I'm here to help manage your calls professionally.",
        "Hindi":
            "नमस्ते, मैं आपका AI सहायक हूं। मैं आपकी कॉल्स को व्यावसायिक तरीके से संभालने के लिए यहां हूं।",
        "Telugu":
            "నమస్కారం, నేను మీ AI సహాయకుడిని. నేను మీ కాల్స్‌ను వృత్తిపరంగా నిర్వహించడానికి ఇక్కడ ఉన్నాను."
      }
    },
    {
      "id": "female_voice_1",
      "type": "Female",
      "name": "Priya",
      "description":
          "Friendly and approachable voice, ideal for customer service and personal interactions",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "sampleText": {
        "English":
            "Hi there! I'm your AI assistant and I'll be handling your calls with care and professionalism.",
        "Hindi":
            "हैलो! मैं आपकी AI सहायक हूं और मैं आपकी कॉल्स को सावधानी और व्यावसायिकता के साथ संभालूंगी।",
        "Telugu":
            "హాయ్! నేను మీ AI సహాయకురాలిని మరియు నేను మీ కాల్స్‌ను జాగ్రత్తగా మరియు వృత్తిపరంగా నిర్వహిస్తాను."
      }
    }
  ];

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _selectVoice(String voiceId) {
    setState(() {
      _selectedVoice = voiceId;
      _hasPreviewedSelected = false;
    });
    HapticFeedback.lightImpact();
  }

  void _previewVoice(String voiceId) async {
    if (_isPlaying && _currentPlayingVoice == voiceId) {
      _stopPreview();
      return;
    }

    if (_isPlaying) {
      _stopPreview();
    }

    setState(() {
      _isPlaying = true;
      _currentPlayingVoice = voiceId;
      _playbackPosition = Duration.zero;
    });

    HapticFeedback.mediumImpact();

    // Simulate audio playback with timer
    _playbackTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _playbackPosition = Duration(milliseconds: timer.tick * 100);
      });

      if (_playbackPosition >= _playbackDuration) {
        _stopPreview();
        if (_selectedVoice == voiceId) {
          setState(() {
            _hasPreviewedSelected = true;
          });
        }
      }
    });

    // Auto-stop after duration
    Timer(_playbackDuration, () {
      if (_isPlaying && _currentPlayingVoice == voiceId) {
        _stopPreview();
        if (_selectedVoice == voiceId) {
          setState(() {
            _hasPreviewedSelected = true;
          });
        }
      }
    });
  }

  void _stopPreview() {
    _playbackTimer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentPlayingVoice = null;
      _playbackPosition = Duration.zero;
    });
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    HapticFeedback.selectionClick();
  }

  void _onVolumeChanged(double volume) {
    setState(() {
      _volume = volume;
    });
  }

  void _previewAgain() {
    if (_selectedVoice != null) {
      _previewVoice(_selectedVoice!);
    }
  }

  void _continue() {
    if (_selectedVoice != null && _hasPreviewedSelected) {
      // Store selected voice preference
      Navigator.pushNamed(context, '/name-input-and-profile-setup');
    }
  }

  bool get _canContinue => _selectedVoice != null && _hasPreviewedSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
        title: Text(
          'Voice Selection',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Assistant Voice',
                            style: AppTheme.darkTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'This voice will represent you during calls. Preview each option to find the perfect match for your communication style.',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Voice options
                    ...(_voiceOptions as List).map((dynamic voice) {
                      final voiceMap = voice as Map<String, dynamic>;
                      final isSelected = _selectedVoice == voiceMap["id"];
                      final isPlaying =
                          _isPlaying && _currentPlayingVoice == voiceMap["id"];

                      return VoiceOptionCard(
                        voiceType: voiceMap["type"] as String,
                        voiceName: voiceMap["name"] as String,
                        description: voiceMap["description"] as String,
                        avatarUrl: voiceMap["avatar"] as String,
                        isSelected: isSelected,
                        isPlaying: isPlaying,
                        onTap: () => _selectVoice(voiceMap["id"] as String),
                        onPreview: () =>
                            _previewVoice(voiceMap["id"] as String),
                      );
                    }).toList(),

                    // Audio waveform (shown when playing)
                    if (_isPlaying)
                      AudioWaveformWidget(
                        isPlaying: _isPlaying,
                        duration: _playbackDuration,
                        position: _playbackPosition,
                      ),

                    // Language toggle
                    LanguageToggleWidget(
                      selectedLanguage: _selectedLanguage,
                      onLanguageChanged: _onLanguageChanged,
                    ),

                    // Volume slider
                    VolumeSliderWidget(
                      volume: _volume,
                      onVolumeChanged: _onVolumeChanged,
                    ),

                    SizedBox(height: 2.h),

                    // Preview again button
                    if (_selectedVoice != null && !_isPlaying)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: OutlinedButton.icon(
                          onPressed: _previewAgain,
                          icon: CustomIconWidget(
                            iconName: 'replay',
                            color: AppTheme.textPrimary,
                            size: 20,
                          ),
                          label: Text('Preview Again'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                        ),
                      ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            // Bottom action area
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlack,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.borderSubtle,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Progress indicator
                  if (_selectedVoice != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: _hasPreviewedSelected
                                ? 'check_circle'
                                : 'radio_button_unchecked',
                            color: _hasPreviewedSelected
                                ? AppTheme.activeGreen
                                : AppTheme.textSecondary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _hasPreviewedSelected
                                ? 'Voice selected and previewed'
                                : 'Preview your selected voice to continue',
                            style: AppTheme.darkTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: _hasPreviewedSelected
                                  ? AppTheme.activeGreen
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _canContinue ? _continue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canContinue
                            ? AppTheme.activeGreen
                            : AppTheme.borderSubtle,
                        foregroundColor: _canContinue
                            ? AppTheme.primaryBlack
                            : AppTheme.textSecondary,
                      ),
                      child: Text(
                        'Continue',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: _canContinue
                              ? AppTheme.primaryBlack
                              : AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
