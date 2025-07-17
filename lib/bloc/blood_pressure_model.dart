///   blood pressure entry model
class BloodPressureModel {
  /// id
  final int id;

  /// systolic pressure
  final int systolic;

  /// diastolic pressure
  final int diastolic;

  /// pulse
  final int pulse;

  /// date time
  final DateTime dateTime;

  /// constructor
  BloodPressureModel({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.dateTime,
  });

  /// from map
  factory BloodPressureModel.fromMap(Map<String, dynamic> map) {
    return BloodPressureModel(
      id: map['id'] as int,
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
      pulse: map['pulse'] as int,
      dateTime: DateTime.parse(map['dateTime'] as String),
    );
  }

  /// Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
