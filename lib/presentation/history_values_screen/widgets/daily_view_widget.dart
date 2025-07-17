import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/save_blood_pressure_status_enum.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/getters/status_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// Daily view widget for displaying blood pressure measurements for a specific day
class DailyViewWidget extends StatefulWidget {
  /// Constructor for the daily view widget
  const DailyViewWidget({
    /// Callback function to notify parent widget of day change
    required this.onDayChange,
    super.key,
  });

  /// Callback function to notify parent widget of day change
  final Function(DateTime) onDayChange;

  @override
  State<DailyViewWidget> createState() => _DailyViewWidgetState();
}

class _DailyViewWidgetState extends State<DailyViewWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadDailyData();
  }

  void _loadDailyData() {
    widget.onDayChange(_selectedDate);
  }

  Color _getStatusColor(BloodPressureModel entry) {
    if (entry.systolic >= 140 || entry.diastolic >= 90) {
      return Colors.red;
    } else if (entry.systolic >= 130 || entry.diastolic >= 80) {
      return Colors.orange;
    } else if (entry.systolic >= 120) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(
                      const Duration(days: 1),
                    );
                  });
                  _loadDailyData();
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(const Duration(days: 1));
                  });
                  _loadDailyData();
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              BlocBuilder<
                SaveBloodPressureEntriesBloc,
                SaveBloodPressureEntrysState
              >(
                builder: (_, state) {
                  if (state.status == SaveBloodPressureEntrysStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == SaveBloodPressureEntrysStatus.error) {
                    return const Center(
                      child: Text('No measurements available'),
                    );
                  }
                  if (state.status == SaveBloodPressureEntrysStatus.loaded) {
                    final entries = state.result.cast<BloodPressureModel>();
                    if (entries.isEmpty) {
                      return const Center(
                        child: Text('No measurements for this day'),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(2.w),
                      itemCount: entries.length,
                      itemBuilder: (_, index) {
                        final entry = entries[index];

                        return Card(
                          margin: EdgeInsets.only(bottom: 2.w),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(entry),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                            ),
                            title: Row(
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
                                  '${entry.systolic} /',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' DIA ',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${entry.diastolic} mmHg',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Pulse: ${entry.pulse} bpm\nTime: ${_formatTime(entry.dateTime)}',
                            ),
                            trailing: Text(
                              getStatusText(entry),
                              style: TextStyle(
                                color: _getStatusColor(entry),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: Text('No data available'));
                },
              ),
        ),
      ],
    );
  }
}
