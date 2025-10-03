import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/audio_waveform_widget.dart';
import './widgets/call_action_buttons.dart';
import './widgets/caller_info_header.dart';
import './widgets/live_transcript_widget.dart';

class LiveCallScreen extends StatefulWidget {
  const LiveCallScreen({Key? key}) : super(key: key);

  @override
  State<LiveCallScreen> createState() => _LiveCallScreenState();
}

class _LiveCallScreenState extends State<LiveCallScreen> {
  // Call state variables
  Timer? _callTimer;
  Duration _callDuration = Duration.zero;
  bool _isUserInCall = false;
  bool _isAIMuted = false;
  bool _isAutoScrollEnabled = true;
  bool _isRecording = true;
  double _audioActivityLevel = 0.7;

  // Mock caller data
  final Map<String, dynamic> _callerData = {
    "id": "caller_001",
    "name": "Rajesh Kumar",
    "phoneNumber": "+91 98765 43210",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "location": "Mumbai, Maharashtra",
    "callType": "delivery",
  };

  // Mock transcript messages
  final List<Map<String, dynamic>> _transcriptMessages = [
    {
      "id": "msg_001",
      "sender": "AI",
      "content":
          "Hello! Thank you for calling. I'm the AI assistant for this number. How can I help you today?",
      "timestamp": "13:04",
      "confidence": 1.0,
    },
    {
      "id": "msg_002",
      "sender": "Caller",
      "content":
          "Hi, I'm calling about a food delivery. I'm outside the building but I can't find the exact apartment number.",
      "timestamp": "13:04",
      "confidence": 0.95,
    },
    {
      "id": "msg_003",
      "sender": "AI",
      "content":
          "I understand you're here for a food delivery. Let me help you with that. Can you tell me which building you're at and I'll guide you to the correct apartment?",
      "timestamp": "13:05",
      "confidence": 1.0,
    },
    {
      "id": "msg_004",
      "sender": "Caller",
      "content":
          "I'm at Tower B, but there are multiple entrances and I'm not sure which one leads to apartment 402.",
      "timestamp": "13:05",
      "confidence": 0.88,
    },
    {
      "id": "msg_005",
      "sender": "AI",
      "content":
          "Perfect! For apartment 402 in Tower B, you need to use the main entrance which faces the parking area. Once inside, take the elevator to the 4th floor. Apartment 402 will be on your right as you exit the elevator.",
      "timestamp": "13:06",
      "confidence": 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startCallTimer();
    _simulateRealTimeUpdates();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration = Duration(seconds: _callDuration.inSeconds + 1);
      });
    });
  }

  void _simulateRealTimeUpdates() {
    // Simulate periodic audio activity changes
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && !_isAIMuted) {
        setState(() {
          _audioActivityLevel = 0.3 + (0.7 * (timer.tick % 4) / 4);
        });
      }
    });

    // Simulate new messages arriving
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _transcriptMessages.add({
            "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
            "sender": "Caller",
            "content":
                "Thank you so much! That's very helpful. I can see the main entrance now.",
            "timestamp": _formatTime(DateTime.now()),
            "confidence": 0.92,
          });
        });
      }
    });
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _handleJoinCall() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isUserInCall = true;
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.activeGreen,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              "You're now connected to the call",
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.contentSurface,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleEndCall() {
    HapticFeedback.mediumImpact();
    _showEndCallDialog();
  }

  void _showEndCallDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.contentSurface,
          title: Text(
            'End Call',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to end this call? The conversation will be saved to your call history.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Return to previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
              ),
              child: Text(
                'End Call',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleMuteAI() {
    HapticFeedback.lightImpact();
    setState(() {
      _isAIMuted = !_isAIMuted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAIMuted ? 'AI Assistant muted' : 'AI Assistant unmuted',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.contentSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAddNote() {
    HapticFeedback.lightImpact();
    _showAddNoteDialog();
  }

  void _showAddNoteDialog() {
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.contentSurface,
          title: Text(
            'Add Note',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          content: TextField(
            controller: noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add a note about this call...',
              hintStyle: TextStyle(color: AppTheme.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(color: AppTheme.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(color: AppTheme.activeGreen),
              ),
            ),
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (noteController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Note added successfully',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      backgroundColor: AppTheme.contentSurface,
                    ),
                  );
                }
              },
              child: Text('Save Note'),
            ),
          ],
        );
      },
    );
  }

  void _handleScrollOverride() {
    setState(() {
      _isAutoScrollEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Column(
        children: [
          // Caller information header
          CallerInfoHeader(
            callerData: _callerData,
            callDuration: _formatDuration(_callDuration),
          ),

          // Audio waveform visualization
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: AudioWaveformWidget(
              isActive: !_isAIMuted && _isRecording,
              activityLevel: _audioActivityLevel,
            ),
          ),

          // Live transcript area
          Expanded(
            child: LiveTranscriptWidget(
              messages: _transcriptMessages,
              isAutoScrollEnabled: _isAutoScrollEnabled,
              onScrollOverride: _handleScrollOverride,
            ),
          ),

          // Call action buttons
          CallActionButtons(
            onJoinCall: _handleJoinCall,
            onEndCall: _handleEndCall,
            onMuteAI: _handleMuteAI,
            onAddNote: _handleAddNote,
            isAIMuted: _isAIMuted,
            isUserInCall: _isUserInCall,
          ),
        ],
      ),
    );
  }
}
