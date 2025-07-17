part of 'save_blood_pressure_entries_bloc.dart';

@immutable
/// save blood pressure entrys event
// ignore: prefer_match_file_name
sealed class SaveBloodPressureEntrysEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// save blood pressure event
class SaveBloodPressureEvent extends SaveBloodPressureEntrysEvent {
  /// entry to save
  final BloodPressureModel entry;

  /// constructor of the save blood pressure event
  SaveBloodPressureEvent({required this.entry});
}

/// load entries by date event
class LoadEntriesByDateEvent extends SaveBloodPressureEntrysEvent {
  /// date to load entries for
  final DateTime date;

  /// constructor of the load entries by date event
  LoadEntriesByDateEvent({required this.date});
}

/// load entries by week event
class LoadEntriesByWeekEvent extends SaveBloodPressureEntrysEvent {
  /// start date of the week
  final DateTime startDate;

  /// constructor of the load entries by week event
  LoadEntriesByWeekEvent({required this.startDate});
}

/// load entries by month event
class LoadEntriesByMonthEvent extends SaveBloodPressureEntrysEvent {
  /// year and month to load entries for
  final int year;

  /// month to load entries for
  final int month;

  /// constructor of the load entries by month event
  LoadEntriesByMonthEvent({required this.year, required this.month});
}
