import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/legent_item_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// chart widget
class ChartWidget extends StatefulWidget {
  /// entries list
  final List<BloodPressureModel> entries;
  /// period
  final String period;

  const ChartWidget({
    super.key,
    required this.entries,
    required this.period,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  Map<DateTime, List<BloodPressureModel>> groupedEntries = {};
  List<FlSpot> systolicSpots = [];
  List<FlSpot> diastolicSpots = [];
  List<FlSpot> pulseSpots = [];

  @override
  void initState() {
    super.initState();
    _processData();
  }


  void _processData() {
    // Group entries by day for better visualization
    groupedEntries = {};
    for (final entry in widget.entries) {
      final dateKey = DateTime(
        entry.dateTime.year,
        entry.dateTime.month,
        entry.dateTime.day,
      );
      groupedEntries.putIfAbsent(dateKey, () => []).add(entry);
    }

    systolicSpots = [];
    diastolicSpots = [];
    pulseSpots = [];

    int index = 0;
    for (final dateKey in groupedEntries.keys.toList()..sort()) {
      final dayEntries = groupedEntries[dateKey]!;
      final avgSystolic =
          dayEntries.map((e) => e.systolic).reduce((a, b) => a + b) /
          dayEntries.length;
      final avgDiastolic =
          dayEntries.map((e) => e.diastolic).reduce((a, b) => a + b) /
          dayEntries.length;
      final avgPulse =
          dayEntries.map((e) => e.pulse).reduce((a, b) => a + b) /
          dayEntries.length;

      systolicSpots.add(FlSpot(index.toDouble(), avgSystolic));
      diastolicSpots.add(FlSpot(index.toDouble(), avgDiastolic));
      pulseSpots.add(FlSpot(index.toDouble(), avgPulse));
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          Text(
            '${widget.period} Blood Pressure & Pulse Trends',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 15.sp),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1, // Show every date label to avoid duplicates
                      getTitlesWidget: (value, _) {
                        logger.i("value $groupedEntries");
                        final index = value.toInt();
                        // Build a sorted list of unique dates
                        final uniqueDates = groupedEntries.keys.toSet().toList()
                          ..sort((a, b) => a.compareTo(b));
                        if (index >= 0 && index < uniqueDates.length) {
                          final date = uniqueDates[index];

                          return Text(
                            '${date.day}/${date.month}',
                            style: TextStyle(fontSize: 15.sp),
                          );
                        }

                        return const Text('');
                      },

                      //   return const Text('');
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: systolicSpots,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: diastolicSpots,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: pulseSpots,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
                minY: 0,
                maxY: 200,
              ),
            ),
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LegentItem(label: 'Systolic', color: Colors.red),
              LegentItem(label: 'Diastolic', color: Colors.blue),
              LegentItem(label: 'Pulse', color: Colors.green),
            ],
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(ChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries || oldWidget.period != widget.period) {
      _processData();
    }
  }
}



// Legacy function for backward compatibility
Widget buildChart(List<BloodPressureModel> entries, String period) {
  return ChartWidget(entries: entries, period: period);
}
