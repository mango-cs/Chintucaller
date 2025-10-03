import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dual_sim_progress_widget.dart';
import './widgets/overall_progress_header.dart';
import './widgets/progress_stage_card.dart';
import './widgets/success_completion_widget.dart';

class ProgressStageData {
  final String title;
  final String description;
  ProgressStageStatus status;
  int? remainingSeconds;
  final String? errorMessage;
  final VoidCallback? onRetry;

  ProgressStageData({
    required this.title,
    required this.description,
    required this.status,
    this.remainingSeconds,
    this.errorMessage,
    this.onRetry,
  });
}

class ActivatingAssistantProgress extends StatefulWidget {
  const ActivatingAssistantProgress({Key? key}) : super(key: key);

  @override
  State<ActivatingAssistantProgress> createState() =>
      _ActivatingAssistantProgressState();
}

class _ActivatingAssistantProgressState
    extends State<ActivatingAssistantProgress> {
  Timer? _progressTimer;
  int _currentStageIndex = 0;
  bool _isSetupComplete = false;
  bool _isDualSim = true;
  bool _sim1Expanded = true;
  bool _sim2Expanded = false;
  int _overallProgress = 0;
  String _estimatedTime = "2-3 minutes";

  // Mock SIM data
  final List<Map<String, dynamic>> _simData = [
    {
      "name": "SIM 1 - Primary",
      "carrier": "Airtel India",
      "stages": <ProgressStageData>[],
    },
    {
      "name": "SIM 2 - Secondary",
      "carrier": "Jio India",
      "stages": <ProgressStageData>[],
    },
  ];

  // Single SIM stages for non-dual SIM users
  List<ProgressStageData> _singleSimStages = [];

  @override
  void initState() {
    super.initState();
    _initializeStages();
    _startProgressSimulation();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _initializeStages() {
    final stageTemplates = [
      {
        "title": "When Busy",
        "description": "Configuring *67* call forwarding",
        "duration": 15,
      },
      {
        "title": "When Unreachable",
        "description": "Setting up *62* forwarding rules",
        "duration": 20,
      },
      {
        "title": "Verifying Connection",
        "description": "Testing forwarding configuration",
        "duration": 25,
      },
      {
        "title": "When Unanswered",
        "description": "Configuring *61* forwarding",
        "duration": 18,
      },
      {
        "title": "Setup Complete",
        "description": "Final verification and activation",
        "duration": 12,
      },
    ];

    // Initialize single SIM stages
    _singleSimStages = stageTemplates
        .map((template) => ProgressStageData(
              title: template["title"] as String,
              description: template["description"] as String,
              status: ProgressStageStatus.pending,
              remainingSeconds: template["duration"] as int,
            ))
        .toList();

    // Initialize dual SIM stages
    for (int i = 0; i < _simData.length; i++) {
      _simData[i]["stages"] = stageTemplates
          .map((template) => ProgressStageData(
                title: template["title"] as String,
                description: template["description"] as String,
                status: ProgressStageStatus.pending,
                remainingSeconds: template["duration"] as int,
                onRetry: () => _retryStage(i, stageTemplates.indexOf(template)),
              ))
          .toList();
    }

    // Start with first stage active
    if (_isDualSim) {
      (_simData[0]["stages"] as List<ProgressStageData>)[0].status =
          ProgressStageStatus.active;
    } else {
      _singleSimStages[0].status = ProgressStageStatus.active;
    }
  }

  void _startProgressSimulation() {
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateProgress();
      });
    });
  }

  void _updateProgress() {
    if (_isSetupComplete) return;

    if (_isDualSim) {
      _updateDualSimProgress();
    } else {
      _updateSingleSimProgress();
    }

    _calculateOverallProgress();
  }

  void _updateSingleSimProgress() {
    if (_currentStageIndex >= _singleSimStages.length) {
      _completeSetup();
      return;
    }

    final currentStage = _singleSimStages[_currentStageIndex];
    if (currentStage.status == ProgressStageStatus.active) {
      if (currentStage.remainingSeconds != null &&
          currentStage.remainingSeconds! > 0) {
        currentStage.remainingSeconds = currentStage.remainingSeconds! - 1;
      } else {
        // Complete current stage
        currentStage.status = ProgressStageStatus.completed;
        _currentStageIndex++;

        // Start next stage if available
        if (_currentStageIndex < _singleSimStages.length) {
          _singleSimStages[_currentStageIndex].status =
              ProgressStageStatus.active;
        } else {
          _completeSetup();
        }
      }
    }
  }

  void _updateDualSimProgress() {
    bool allCompleted = true;

    for (int simIndex = 0; simIndex < _simData.length; simIndex++) {
      final stages = _simData[simIndex]["stages"] as List<ProgressStageData>;

      for (int stageIndex = 0; stageIndex < stages.length; stageIndex++) {
        final stage = stages[stageIndex];

        if (stage.status == ProgressStageStatus.active) {
          if (stage.remainingSeconds != null && stage.remainingSeconds! > 0) {
            stage.remainingSeconds = stage.remainingSeconds! - 1;
            allCompleted = false;
          } else {
            // Complete current stage
            stage.status = ProgressStageStatus.completed;

            // Start next stage if available
            if (stageIndex + 1 < stages.length) {
              stages[stageIndex + 1].status = ProgressStageStatus.active;
              allCompleted = false;
            }
          }
          break;
        } else if (stage.status == ProgressStageStatus.pending ||
            stage.status == ProgressStageStatus.active) {
          allCompleted = false;
        }
      }
    }

    if (allCompleted) {
      _completeSetup();
    }
  }

  void _calculateOverallProgress() {
    if (_isDualSim) {
      int totalStages = 0;
      int completedStages = 0;

      for (final simData in _simData) {
        final stages = simData["stages"] as List<ProgressStageData>;
        totalStages += stages.length;
        completedStages += stages
            .where((s) => s.status == ProgressStageStatus.completed)
            .length;
      }

      _overallProgress =
          totalStages > 0 ? (completedStages / totalStages * 100).round() : 0;
    } else {
      final completedStages = _singleSimStages
          .where((s) => s.status == ProgressStageStatus.completed)
          .length;
      _overallProgress = (_singleSimStages.isNotEmpty)
          ? (completedStages / _singleSimStages.length * 100).round()
          : 0;
    }

    // Update estimated time based on progress
    if (_overallProgress < 25) {
      _estimatedTime = "2-3 minutes";
    } else if (_overallProgress < 50) {
      _estimatedTime = "1-2 minutes";
    } else if (_overallProgress < 75) {
      _estimatedTime = "30-60 seconds";
    } else {
      _estimatedTime = "Almost done";
    }
  }

  void _completeSetup() {
    _progressTimer?.cancel();
    setState(() {
      _isSetupComplete = true;
      _overallProgress = 100;
      _estimatedTime = "Complete";
    });
  }

  void _retryStage(int simIndex, int stageIndex) {
    setState(() {
      final stages = _simData[simIndex]["stages"] as List<ProgressStageData>;
      stages[stageIndex].status = ProgressStageStatus.active;
      stages[stageIndex].remainingSeconds = 15; // Reset timer
    });
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-dashboard',
      (route) => false,
    );
  }

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
            size: 6.w,
          ),
        ),
        title: Text(
          'Setting up Assistant',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: _isSetupComplete ? _buildSuccessView() : _buildProgressView(),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: SuccessCompletionWidget(
          onContinue: _navigateToHome,
        ),
      ),
    );
  }

  Widget _buildProgressView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(5.w),
      child: Column(
        children: [
          OverallProgressHeader(
            overallProgress: _overallProgress,
            estimatedTime: _estimatedTime,
            isDualSim: _isDualSim,
          ),
          SizedBox(height: 3.h),
          if (_isDualSim)
            ..._buildDualSimProgress()
          else
            ..._buildSingleSimProgress(),
          SizedBox(height: 3.h),
          _buildHelpSection(),
        ],
      ),
    );
  }

  List<Widget> _buildDualSimProgress() {
    return [
      DualSimProgressWidget(
        simName: _simData[0]["name"] as String,
        carrier: _simData[0]["carrier"] as String,
        stages: _simData[0]["stages"] as List<ProgressStageData>,
        isExpanded: _sim1Expanded,
        onToggleExpansion: () => setState(() => _sim1Expanded = !_sim1Expanded),
      ),
      SizedBox(height: 2.h),
      DualSimProgressWidget(
        simName: _simData[1]["name"] as String,
        carrier: _simData[1]["carrier"] as String,
        stages: _simData[1]["stages"] as List<ProgressStageData>,
        isExpanded: _sim2Expanded,
        onToggleExpansion: () => setState(() => _sim2Expanded = !_sim2Expanded),
      ),
    ];
  }

  List<Widget> _buildSingleSimProgress() {
    return _singleSimStages
        .map((stage) => ProgressStageCard(
              title: stage.title,
              description: stage.description,
              status: stage.status,
              remainingSeconds: stage.remainingSeconds,
              errorMessage: stage.errorMessage,
              onRetry: stage.onRetry,
            ))
        .toList();
  }

  Widget _buildHelpSection() {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.contentSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.warningAmber,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'What\'s happening?',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'We\'re configuring call forwarding rules using GSM codes (*67*, *62*, *61*) to ensure your AI Assistant can handle calls when you\'re busy, unreachable, or don\'t answer.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () {
              // Show manual setup instructions
              _showManualSetupDialog();
            },
            child: Text(
              'Need manual setup?',
              style: TextStyle(color: AppTheme.activeGreen),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.contentSurface,
        title: Text(
          'Manual Setup Instructions',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If automatic setup fails, you can manually configure call forwarding:',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            _buildManualStep('1. When Busy:', 'Dial *67*[AI_NUMBER]#'),
            _buildManualStep('2. When Unreachable:', 'Dial *62*[AI_NUMBER]#'),
            _buildManualStep('3. When Unanswered:', 'Dial *61*[AI_NUMBER]#'),
            SizedBox(height: 2.h),
            Text(
              'Replace [AI_NUMBER] with the number provided in your account settings.',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.warningAmber,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(color: AppTheme.activeGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualStep(String title, String instruction) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              instruction,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.activeGreen,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}