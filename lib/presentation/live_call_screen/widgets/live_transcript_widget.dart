import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class LiveTranscriptWidget extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  final bool isAutoScrollEnabled;
  final VoidCallback? onScrollOverride;

  const LiveTranscriptWidget({
    Key? key,
    required this.messages,
    this.isAutoScrollEnabled = true,
    this.onScrollOverride,
  }) : super(key: key);

  @override
  State<LiveTranscriptWidget> createState() => _LiveTranscriptWidgetState();
}

class _LiveTranscriptWidgetState extends State<LiveTranscriptWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _userScrolledManually = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50;

      if (!isAtBottom && !_userScrolledManually) {
        setState(() {
          _userScrolledManually = true;
        });
        widget.onScrollOverride?.call();
      }
    }
  }

  @override
  void didUpdateWidget(LiveTranscriptWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAutoScrollEnabled && !_userScrolledManually) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _scrollToBottom() {
    setState(() {
      _userScrolledManually = false;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4.w),
        ),
      ),
      child: Column(
        children: [
          // Header with transcript title
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'record_voice_over',
                  color: AppTheme.activeGreen,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Live Transcript',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_userScrolledManually)
                  GestureDetector(
                    onTap: _scrollToBottom,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.activeGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'keyboard_arrow_down',
                            color: AppTheme.lightTheme.scaffoldBackgroundColor,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Latest',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color:
                                  AppTheme.lightTheme.scaffoldBackgroundColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Messages list
          Expanded(
            child: widget.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'hearing',
                          color: AppTheme.textSecondary,
                          size: 12.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Listening to conversation...',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    itemCount: widget.messages.length,
                    itemBuilder: (context, index) {
                      final message = widget.messages[index];
                      final isAI = (message['sender'] as String?) == 'AI';
                      final confidence =
                          (message['confidence'] as double?) ?? 1.0;

                      return Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: isAI
                                    ? AppTheme.activeGreen
                                    : AppTheme.textSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: isAI ? 'smart_toy' : 'person',
                                color:
                                    AppTheme.lightTheme.scaffoldBackgroundColor,
                                size: 4.w,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            // Message content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Sender and timestamp
                                  Row(
                                    children: [
                                      Text(
                                        isAI ? 'AI Assistant' : 'Caller',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isAI
                                              ? AppTheme.activeGreen
                                              : AppTheme.textSecondary,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        (message['timestamp'] as String?) ?? '',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      if (!isAI && confidence < 0.8) ...[
                                        SizedBox(width: 2.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 0.5.h),
                                          decoration: BoxDecoration(
                                            color: AppTheme.warningAmber
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Low confidence',
                                            style: AppTheme
                                                .lightTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: AppTheme.warningAmber,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  // Message text
                                  Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: isAI
                                          ? AppTheme.activeGreen
                                              .withValues(alpha: 0.1)
                                          : AppTheme.lightTheme.cardColor,
                                      borderRadius: BorderRadius.circular(3.w),
                                      border: Border.all(
                                        color: isAI
                                            ? AppTheme.activeGreen
                                                .withValues(alpha: 0.3)
                                            : AppTheme.lightTheme.dividerColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      (message['content'] as String?) ?? '',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
