// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_repo.dart';
import 'package:bloddpressuretrackerapp/enums/save_blood_pressure_status_enum.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'save_blood_pressure_entries_event.dart';
part 'save_blood_pressure_entrys_state.dart';

/// save blood pressure entrys bloc
class SaveBloodPressureEntriesBloc
    extends Bloc<SaveBloodPressureEntrysEvent, SaveBloodPressureEntrysState> {
  /// repository for the save blood pressure entrys
  final SaveBloodRepo repository = SaveBloodRepo();

  /// constructor of the save blood pressure entrys bloc
  SaveBloodPressureEntriesBloc() : super(const SaveBloodPressureEntrysState()) {
    on<SaveBloodPressureEvent>(
      (event, emit) => saveBloodPressure(event: event, emit: emit),
    );
    on<LoadEntriesByDateEvent>(
      (event, emit) => loadEntriesByDate(event: event, emit: emit),
    );
    on<LoadEntriesByWeekEvent>(
      (event, emit) => loadEntriesByWeek(event: event, emit: emit),
    );
    on<LoadEntriesByMonthEvent>(
      (event, emit) => loadEntriesByMonth(event: event, emit: emit),
    );
  }

  /// save blood pressure entrys function
  Future<void> saveBloodPressure({
    required SaveBloodPressureEvent event,
    required Emitter<SaveBloodPressureEntrysState> emit,
  }) async {
    emit(state.copyWith(status: SaveBloodPressureEntrysStatus.loading));
    try {
      logger.i('Saving entry: ${event.entry.dateTime}');
      await repository.insertEntry(event.entry);
      emit(state.copyWith(status: SaveBloodPressureEntrysStatus.saved));
    } catch (e) {
      emit(
        state.copyWith(
          status: SaveBloodPressureEntrysStatus.error,
          result: <BloodPressureModel>[],
        ),
      );
    }
  }

  /// load entries by date function
  Future<void> loadEntriesByDate({
    required LoadEntriesByDateEvent event,
    required Emitter<SaveBloodPressureEntrysState> emit,
  }) async {
    emit(state.copyWith(status: SaveBloodPressureEntrysStatus.loading));
    try {
      final entries = await repository.fetchEntriesByDate(event.date);
      logger.i('Entries: $entries');
      if (entries.isEmpty) {
        emit(
          state.copyWith(
            status: SaveBloodPressureEntrysStatus.error,
            result: const <BloodPressureModel>[],
          ),
        );
        
        return;
      }
      emit(
        state.copyWith(
          status: SaveBloodPressureEntrysStatus.loaded,
          result: entries,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SaveBloodPressureEntrysStatus.error,
          result: const <BloodPressureModel>[],
        ),
      );
    }
  }

  /// load entries by week function
  Future<void> loadEntriesByWeek({
    required LoadEntriesByWeekEvent event,
    required Emitter<SaveBloodPressureEntrysState> emit,
  }) async {
    emit(state.copyWith(status: SaveBloodPressureEntrysStatus.loading));
    try {
      final entries = await repository.fetchEntriesByWeek(event.startDate);
      logger.i('Week entries: ${entries.length} found');
      emit(
        state.copyWith(
          status: SaveBloodPressureEntrysStatus.loaded,
          result: entries,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SaveBloodPressureEntrysStatus.error,
          result: const <BloodPressureModel>[],
        ),
      );
    }
  }

  /// load entries by month function
  Future<void> loadEntriesByMonth({
    required LoadEntriesByMonthEvent event,
    required Emitter<SaveBloodPressureEntrysState> emit,
  }) async {
    emit(state.copyWith(status: SaveBloodPressureEntrysStatus.loading));
    try {
      final entries = await repository.fetchEntriesByMonth(
        event.year,
        event.month,
      );
      logger.i('Month entries: ${entries.length} found');
      emit(
        state.copyWith(
          status: SaveBloodPressureEntrysStatus.loaded,
          result: entries,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SaveBloodPressureEntrysStatus.error,
          result: const <BloodPressureModel>[],
        ),
      );
    }
  }
}
