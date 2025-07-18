import 'package:bloddpressuretrackerapp/enums/feedback_enum.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Feedback card widget
class FeedbackCard extends StatefulWidget {
  /// show feedback
  final bool showFeedback;
  /// current feedback
  final FeedbackEnum? currentFeedback;
/// 
  const FeedbackCard({
    /// show feedback
    required this.showFeedback,
    /// current feedback
    required this.currentFeedback,
    super.key,
  });

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  @override
  Widget build(BuildContext context) {
    if (!widget.showFeedback || widget.currentFeedback == null) {
      return const SizedBox.shrink();
    }

    Color cardColor;
    String title;
    String emoji;
    String description;

    switch (widget.currentFeedback) {
      case FeedbackEnum.normal:
        cardColor = Colors.green.shade100;
        title = 'Normal';
        emoji = '✅';
        description = 'Your readings are within normal ranges';
      case FeedbackEnum.slightlyAbnormal:
        cardColor = Colors.orange.shade100;
        title = 'Slightly Abnormal';
        emoji = '⚠️';
        description = 'Some readings are slightly outside normal ranges';
      case FeedbackEnum.critical:
        cardColor = Colors.red.shade100;
        title = 'Critical';
        emoji = '❗';
        description = 'Please consult with a healthcare professional';
      default:
        cardColor = Colors.grey.shade200;
        title = '';
        emoji = '';
        description = '';
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 6.w)),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 3.5.w, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
