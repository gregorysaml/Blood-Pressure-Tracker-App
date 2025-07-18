import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/save_blood_pressure_status_enum.dart';
import 'package:bloddpressuretrackerapp/consts/const.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// blood pressure widget
class BloodPressureWidget extends StatefulWidget {
  /// constructor of the blood pressure widget
  const BloodPressureWidget({super.key});

  @override
  State<BloodPressureWidget> createState() => _BloodPressureWidgetState();
}

class _BloodPressureWidgetState extends State<BloodPressureWidget> {
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SaveBloodPressureEntriesBloc>(
      context,
    ).add(LoadEntriesByDateEvent(date: _selectedDate));
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute} ${dateTime.hour >= twelve ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          BlocBuilder<
            SaveBloodPressureEntriesBloc,
            SaveBloodPressureEntrysState
          >(
            builder:
                (BuildContext context, SaveBloodPressureEntrysState state) {
                  logger.i('State: ${state.status}');
                  if (state.status == SaveBloodPressureEntrysStatus.error) {
                    return SizedBox(
                      height: 28.h,
                      width: 85.w,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/historyValues');
                        },
                        child: SizedBox(
                          width: 85.w,
                          child: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "No Blood Pressure measurement for today",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (state.status == SaveBloodPressureEntrysStatus.loaded) {
                    final entry =
                        (state.result as List<BloodPressureModel>?) ??
                        <BloodPressureModel>[];

                    return SizedBox(
                      height: 28.h,
                      width: 85.w,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/historyValues');
                        },
                        child: SizedBox(
                          width: 85.w,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 2.w),
                            child: Column(
                              children: [
                                SizedBox(height: 1.h),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Latest Measurement',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SYS  ',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.cyan,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${entry.last.systolic}',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '  mmHg',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'DIA  ',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${entry.last.systolic}',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '  mmHg',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Column(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                              '${entry.last.pulse} ',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'bpm',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formatTime(entry.last.dateTime),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
          ),
    );
  }
}
