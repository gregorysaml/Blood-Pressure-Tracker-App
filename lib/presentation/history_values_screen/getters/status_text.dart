import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/consts/const.dart';

/// get status text based on blood pressure
String getStatusText(BloodPressureModel entry) {
  if (entry.systolic >= oneHundredForty || entry.diastolic >= ninety) {
    return 'High';
  } else if (entry.systolic >= oneHundredThirty || entry.diastolic >= eighty) {
    return 'Elevated';
  }

  return 'Normal';
}
