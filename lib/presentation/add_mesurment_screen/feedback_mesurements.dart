import 'package:bloddpressuretrackerapp/enums/feedback_enum.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// TODO on result return status always
/// build feedback card
Widget buildFeedbackCard({
  required bool showFeedback,
  required FeedbackEnum? currentFeedback,
}) {
  FeedbackEnum? _currentFeedback;
  if (!showFeedback || currentFeedback == null) {
    return const SizedBox.shrink();
  }

  Color cardColor;
  String title;
  String emoji;
  String description;

  switch (currentFeedback) {
    case FeedbackEnum.normal:
      cardColor = Colors.green.shade100;
      title = 'Normal';
      emoji = '✅';
      description = 'Your readings are within normal ranges';
      break;
    case FeedbackEnum.slightlyAbnormal:
      cardColor = Colors.orange.shade100;
      title = 'Slightly Abnormal';
      emoji = '⚠️';
      description = 'Some readings are slightly outside normal ranges';
      break;
    case FeedbackEnum.critical:
      cardColor = Colors.red.shade100;
      title = 'Critical';
      emoji = '❗';
      description = 'Please consult with a healthcare professional';
      break;
  }

  return Container(
    margin: EdgeInsets.symmetric(vertical: 2.h),
    padding: EdgeInsets.all(3.w),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: cardColor.withOpacity(0.5)),
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
