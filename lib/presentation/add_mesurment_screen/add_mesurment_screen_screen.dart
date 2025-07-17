import 'dart:math';

import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/feedback_enum.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:bloddpressuretrackerapp/presentation/add_mesurment_screen/feedback_mesurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sizer/sizer.dart';

/// Manual Entry Screen for blood pressure measurements
class AddMesurmentScreen extends StatefulWidget {
  /// constructor of the add measurement screen widget
  const AddMesurmentScreen({super.key});

  @override
  State<AddMesurmentScreen> createState() => _AddMesurmentScreenState();
}

class _AddMesurmentScreenState extends State<AddMesurmentScreen> {
  int systolicValue = 120;
  int diastolicValue = 70;
  int pulseValue = 60;
  // Validation constants
  static const int _minSystolic = 50;
  static const int _maxSystolic = 250;
  static const int _minDiastolic = 30;
  static const int _maxDiastolic = 150;
  static const int _minPulse = 30;
  static const int _maxPulse = 200;

  // Medical range constants
  static const int _normalSystolicMin = 90;
  static const int _normalSystolicMax = 120;
  static const int _normalDiastolicMin = 60;
  static const int _normalDiastolicMax = 80;
  static const int _normalPulseMin = 60;
  static const int _normalPulseMax = 100;

  static const int _slightlyAbnormalSystolicMin = 121;
  static const int _slightlyAbnormalSystolicMax = 139;
  static const int _slightlyAbnormalDiastolicMin = 81;
  static const int _slightlyAbnormalDiastolicMax = 89;
  static const int _slightlyAbnormalPulseLowMin = 50;
  static const int _slightlyAbnormalPulseLowMax = 59;
  static const int _slightlyAbnormalPulseHighMin = 101;
  static const int _slightlyAbnormalPulseHighMax = 110;

  static const int _criticalSystolicLow = 90;
  static const int _criticalSystolicHigh = 140;
  static const int _criticalDiastolicLow = 60;
  static const int _criticalDiastolicHigh = 90;
  static const int _criticalPulseLow = 50;
  static const int _criticalPulseHigh = 110;

  DateTime _selectedDateTime = DateTime.now();
  FeedbackEnum? _currentFeedback;
  bool _showFeedback = false;

  String? _validateDiastolic(String? value) {
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

  String? _validatePulse(String? value) {
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

  FeedbackEnum _calculateFeedback(int systolic, int diastolic, int pulse) {
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

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // Prevent future dates
      helpText: 'Select measurement date',
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        helpText: 'Select measurement time',
      );

      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDateTime = newDateTime;
        });
      }
    }
  }

  void _saveMeasurement() {
    final id = Random().nextInt(1000000);
    logger.i('Saving entry: $_selectedDateTime');
    BlocProvider.of<SaveBloodPressureEntriesBloc>(context).add(
      SaveBloodPressureEvent(
        entry: BloodPressureModel(
          systolic: systolicValue,
          diastolic: diastolicValue,
          pulse: pulseValue,
          dateTime: _selectedDateTime,
          id: id,
        ),
      ),
    );
    setState(() {
      _showFeedback = true;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Measurement saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Measurement'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 6.w),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Date and Time Selection
            Center(
              child: SizedBox(
                height: 20.h,
                width: 95.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('Systolic'),
                        Expanded(
                          child: NumberPicker(
                            value: systolicValue,
                            minValue: 40,
                            maxValue: 200,
                            haptics: true,
                            onChanged: (value) =>
                                setState(() => systolicValue = value),
                          ),
                        ),
                        Text('mmHg', style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                    const VerticalDivider(),
                    Column(
                      children: [
                        const Text('Diastolic'),
                        Expanded(
                          child: NumberPicker(
                            value: diastolicValue,
                            minValue: 40,
                            maxValue: 150,
                            haptics: true,
                            onChanged: (value) =>
                                setState(() => diastolicValue = value),
                          ),
                        ),
                        Text('mmHg', style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                    const VerticalDivider(),
                    Column(
                      children: [
                        const Text('Pulse rate'),
                        Expanded(
                          child: NumberPicker(
                            value: pulseValue,
                            minValue: 30,
                            maxValue: 200,
                            haptics: true,
                            onChanged: (value) =>
                                setState(() => pulseValue = value),
                          ),
                        ),
                        Text('bpm', style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Measurement Date & Time',
                    style: TextStyle(
                      fontSize: 4.w,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: _selectDateTime,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} '
                            '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 4.w,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Save Button
            ElevatedButton(
              onPressed: _saveMeasurement,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(6.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              child: Text(
                'Save Measurement',
                style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.w600),
              ),
            ),

            // Feedback Card
            buildFeedbackCard(
              showFeedback: _showFeedback,
              currentFeedback: _currentFeedback,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
