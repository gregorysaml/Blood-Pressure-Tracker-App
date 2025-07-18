import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/save_blood_pressure_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// week view widget
class WeekViewWidget extends StatefulWidget {
  /// constructor of the week view widget
  const WeekViewWidget({
    /// callback function to notify the parent widget of week change
    required this.onWeekChange,

    /// function to build the chart
    required this.buildChart,

    super.key,
  });

  /// callback function to notify the parent widget of week change
  final Function(DateTime) onWeekChange;

  /// function to build the chart
  final Widget Function(List<BloodPressureModel>, String) buildChart;

  @override
  State<WeekViewWidget> createState() => _WeekViewWidgetState();
}

class _WeekViewWidgetState extends State<WeekViewWidget> {
  late DateTime _selectedWeekStart;

  @override
  void initState() {
    super.initState();
    _selectedWeekStart = DateTime.now();
    _loadWeeklyData();
  }

  void _loadWeeklyData() {
    widget.onWeekChange(_selectedWeekStart);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedWeekStart = _selectedWeekStart.subtract(
                      const Duration(days: 7),
                    );
                  });
                  _loadWeeklyData();
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                'Week of ${_selectedWeekStart.day}/${_selectedWeekStart.month}/${_selectedWeekStart.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedWeekStart = _selectedWeekStart.add(
                      const Duration(days: 7),
                    );
                  });
                  _loadWeeklyData();
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
                    return const Center(child: Text('No measurements available'));
                  }
                  if (state.status == SaveBloodPressureEntrysStatus.loaded) {
                    final entries = state.result.cast<BloodPressureModel>();
                    if (entries.isEmpty) {
                      return const Center(
                        child: Text('No measurements for this week'),
                      );
                    }

                    return widget.buildChart(entries, 'Weekly');
                  }

                  return const Center(child: Text('No data available'));
                },
              ),
        ),
      ],
    );
  }
}
