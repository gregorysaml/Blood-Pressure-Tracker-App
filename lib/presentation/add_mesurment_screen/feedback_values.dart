// Validation constants
import 'package:bloddpressuretrackerapp/enums/feedback_enum.dart';

/// Slightly abnormal range constants
const int _slightlyAbnormalSystolicMin = 121;
const int _slightlyAbnormalSystolicMax = 139;
const int _slightlyAbnormalDiastolicMin = 81;
const int _slightlyAbnormalDiastolicMax = 89;
const int _slightlyAbnormalPulseLowMin = 50;
const int _slightlyAbnormalPulseLowMax = 59;
const int _slightlyAbnormalPulseHighMin = 101;
const int _slightlyAbnormalPulseHighMax = 110;

const int _criticalSystolicLow = 90;
const int _criticalSystolicHigh = 140;
const int _criticalDiastolicLow = 60;
const int _criticalDiastolicHigh = 90;
const int _criticalPulseLow = 50;
const int _criticalPulseHigh = 110;

/// CalculateFeedback class
// ignore: prefer_match_file_name
class CalculateFeedback {
  /// Calculate feedback based on systolic, diastolic, and pulse
  FeedbackEnum calculateFeedback(int systolic, int diastolic, int pulse) {
    // Check for critical ranges first
    if (systolic < _criticalSystolicLow ||
        systolic > _criticalSystolicHigh ||
        diastolic < _criticalDiastolicLow ||
        diastolic > _criticalDiastolicHigh ||
        pulse < _criticalPulseLow ||
        pulse > _criticalPulseHigh) {
      return FeedbackEnum.critical;
    }

    // Check for slightly abnormal ranges
    if ((systolic >= _slightlyAbnormalSystolicMin &&
            systolic <= _slightlyAbnormalSystolicMax) ||
        (diastolic >= _slightlyAbnormalDiastolicMin &&
            diastolic <= _slightlyAbnormalDiastolicMax) ||
        (pulse >= _slightlyAbnormalPulseLowMin &&
            pulse <= _slightlyAbnormalPulseLowMax) ||
        (pulse >= _slightlyAbnormalPulseHighMin &&
            pulse <= _slightlyAbnormalPulseHighMax)) {
      return FeedbackEnum.slightlyAbnormal;
    }

    // Normal ranges
    return FeedbackEnum.normal;
  }
}
