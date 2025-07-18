import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// legent item widget
// ignore: prefer_match_file_name
class LegentItem extends StatelessWidget {
  /// label of the legent item
  final String label;

  /// color of the legent item
  final Color color;

  /// constructor of the legent item
  const LegentItem({required this.label, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 1.w),
        Text(label, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }
}
