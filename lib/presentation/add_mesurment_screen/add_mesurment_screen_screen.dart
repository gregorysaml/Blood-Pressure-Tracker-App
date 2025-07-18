import 'dart:math';

import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/feedback_enum.dart';
import 'package:bloddpressuretrackerapp/enums/save_blood_pressure_status_enum.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:bloddpressuretrackerapp/presentation/add_mesurment_screen/feedback_values.dart';
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
  final CalculateFeedback _calculateFeedback = CalculateFeedback();
  int systolicValue = 120;
  int diastolicValue = 70;
  int pulseValue = 60;

  DateTime _selectedDateTime = DateTime.now();
  FeedbackEnum? _currentFeedback;

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
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        helpText: 'Select measurement time',
        context: context,
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
      _currentFeedback = _calculateFeedback.calculateFeedback(
        systolicValue,
        diastolicValue,
        pulseValue,
      );
    });

    _showMyDialog();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Measurement saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Color primaryColor;
        Color backgroundColor;
        Color textColor;
        IconData iconData;
        String title;
        String description;

        switch (_currentFeedback) {
          case FeedbackEnum.normal:
            primaryColor = Colors.green;
            backgroundColor = const Color(0xFFE8F5E8);
            textColor = const Color(0xFF2E7D32);
            iconData = Icons.check_circle_outline;
            title = 'Excellent!';
            description =
                'Your blood pressure readings are within the normal, healthy range.';
          case FeedbackEnum.slightlyAbnormal:
            primaryColor = Colors.orange;
            backgroundColor = const Color(0xFFFFF3E0);
            textColor = Colors.orange;
            iconData = Icons.warning_amber_outlined;
            title = 'Monitor Closely';
            description =
                'Some readings are slightly elevated. Consider lifestyle adjustments.';
          case FeedbackEnum.critical:
            primaryColor = Colors.red;
            backgroundColor = const Color(0xFFFFEBEE);
            textColor = Colors.red;
            iconData = Icons.priority_high_outlined;
            title = 'Attention Required';
            description =
                'Please consult with a healthcare professional as soon as possible.';
          default:
            primaryColor = Colors.grey;
            backgroundColor = Colors.grey.shade100;
            textColor = Colors.grey.shade700;
            iconData = Icons.info_outline;
            title = 'Information';
            description = 'Blood pressure reading recorded.';
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon section
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(iconData, color: primaryColor, size: 8.w),
                ),
                SizedBox(height: 4.w),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 5.w,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.w),

                // Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 3.5.w,
                      color: textColor.withOpacity(0.8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 6.w),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/mainpage');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(vertical: 3.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 4.w,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      SaveBloodPressureEntriesBloc,
      SaveBloodPressureEntrysState
    >(
      listener: (_, state) {
        if (state.status == SaveBloodPressureEntrysStatus.saved) {
          // Navigator.pushReplacementNamed(context, '/mainpage');

          return;
        }
      },
      child: Scaffold(
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
                  padding: EdgeInsets.all(5.w),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
