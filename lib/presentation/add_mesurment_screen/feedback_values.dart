// Validation constants
import 'package:bloddpressuretrackerapp/enums/feedback_enum.dart';

const int _minSystolic = 50;
const int _maxSystolic = 250;
const int _minDiastolic = 30;
const int _maxDiastolic = 150;
const int _minPulse = 30;
const int _maxPulse = 200;

/// Medical range constants
const int _normalSystolicMin = 90;
const int _normalSystolicMax = 120;
const int _normalDiastolicMin = 60;
const int _normalDiastolicMax = 80;
const int _normalPulseMin = 60;
const int _normalPulseMax = 100;

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
class CalculateFeedback {
  /// Validate diastolic pressure
  String? validateDiastolic(String? value) {
    if (value == null || value.isEmpty) {
      return 'Diastolic pressure is required';
    }
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return 'Please enter a valid number';
    }
    if (intValue < _minDiastolic || intValue > _maxDiastolic) {
      return 'Diastolic should be between $_minDiastolic-$_maxDiastolic mmHg';
    }

    return null;
  }

  /// Validate pulse
  String? validatePulse(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pulse is required';
    }
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return 'Please enter a valid number';
    }
    if (intValue < _minPulse || intValue > _maxPulse) {
      return 'Pulse should be between $_minPulse-$_maxPulse bpm';
    }

    return null;
  }

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
