part of 'save_blood_pressure_entries_bloc.dart';

@immutable
/// save blood pressure entrys state
final class SaveBloodPressureEntrysState extends Equatable {
  /// Query Status
  final SaveBloodPressureEntrysStatus status;

  /// results
  final List<BloodPressureModel> result;

  @override
  List<Object> get props => [status, result];

  /// intial State
  const SaveBloodPressureEntrysState({
    this.status = SaveBloodPressureEntrysStatus.initial,
    this.result = const [],
  });

  /// Readable copy of ExtensionsState to push
  SaveBloodPressureEntrysState copyWith({
    SaveBloodPressureEntrysStatus? status,
    List<BloodPressureModel>? result,
  }) {
    return SaveBloodPressureEntrysState(
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  @override
  String toString() {
    return 'SaveBloodPressureEntrysState{status: $status, result: $result}';
  }
}
