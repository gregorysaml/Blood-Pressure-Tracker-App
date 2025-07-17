import 'package:bloddpressuretrackerapp/bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_status_enum.dart';
import 'package:bloddpressuretrackerapp/consts/const.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/chart_widget.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/legent_item_widget.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/getters/month_names.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/widgets/daily_view_widget.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/widgets/monthly_view_widget.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/getters/status_text.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/widgets/week_view_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// all history values widget
class HistoryValues extends StatefulWidget {
  /// constructor of the all history values widget
  const HistoryValues({super.key});

  @override
  State<HistoryValues> createState() => _HistoryValuesState();
}

class _HistoryValuesState extends State<HistoryValues>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedWeekStart = DateTime.now();
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: three, vsync: this);
    _selectedWeekStart = _getWeekStart(DateTime.now());
    _loadInitialData();
  }

  Color _getStatusColor(BloodPressureModel entry) {
    if (entry.systolic > oneHundredForty ||
        entry.systolic < ninety ||
        entry.diastolic > ninety ||
        entry.diastolic < sixty) {
      return Colors.red;
    } else if (entry.systolic >= oneHundredThirty ||
        entry.diastolic >= eighty) {
      return Colors.orange;
    }

    return Colors.green;
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _loadInitialData() {
    BlocProvider.of<SaveBloodPressureEntriesBloc>(
      context,
    ).add(LoadEntriesByDateEvent(date: _selectedDate));
  }

  void _loadDailyData() {
    BlocProvider.of<SaveBloodPressureEntriesBloc>(
      context,
    ).add(LoadEntriesByDateEvent(date: _selectedDate));
  }

  void _loadWeeklyData() {
    BlocProvider.of<SaveBloodPressureEntriesBloc>(
      context,
    ).add(LoadEntriesByWeekEvent(startDate: _selectedWeekStart));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Measurement History'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            switch (index) {
              case 0:
                _loadDailyData();
              case 1:
                _loadWeeklyData();
              case 2:
                _loadMonthlyData();
            }
          },
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          DailyViewWidget(
            onDayChange: (date) {
              _selectedDate = date;
              _loadDailyData();
            },
          ),
          WeekViewWidget(
            onWeekChange: (date) {
              _selectedWeekStart = date;
              _loadWeeklyData();
            },
            buildChart: buildChart,
          ),
          const MonthlyViewWidget(),
        ],
      ),
    );
  }

  // ignore: avoid_returning_widgets

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
