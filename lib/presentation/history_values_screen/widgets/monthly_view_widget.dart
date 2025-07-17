import 'package:bloddpressuretrackerapp/bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_status_enum.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/chart_widget.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/getters/month_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// monthly view widget

class MonthlyViewWidget extends StatefulWidget {
  /// constructor of the monthly view widget
  const MonthlyViewWidget({super.key});

  @override
  State<MonthlyViewWidget> createState() => _MonthlyViewWidgetState();
}

class _MonthlyViewWidgetState extends State<MonthlyViewWidget> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadMonthlyData();
  }

  void _loadMonthlyData() {
    BlocProvider.of<SaveBloodPressureEntriesBloc>(context).add(
      LoadEntriesByMonthEvent(
        year: _selectedMonth.year,
        month: _selectedMonth.month,
      ),
    );
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
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month - 1,
                    );
                  });
                  _loadMonthlyData();
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${getMonthName(_selectedMonth.month)} ${_selectedMonth.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month + 1,
                    );
                  });
                  _loadMonthlyData();
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
                        child: Text('No measurements for this month'),
                      );
                    }

                    return buildChart(entries, 'Monthly');
                  }

                  return const Center(child: Text('No data available'));
                },
              ),
        ),
      ],
    );
  }
}
