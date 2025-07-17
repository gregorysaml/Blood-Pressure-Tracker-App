/// visual feedback enum
enum FeedbackEnum {
  /// normal systolic 90-120 mmHg
  /// Diastolic: 60–80
  /// Pulse: 60–100
  normal,

  /// high systolic 121-139 mmHg
  /// Diastolic: 81–89
  /// Pulse: 50–59 101–110
  slightlyAbnormal,

  /// critical systolic <90 or >140
  /// Diastolic: <60 or >90
  /// Pulse:<50 or >110
  critical,
}
