import 'package:bloddpressuretrackerapp/presentation/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// main method
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal Portrait
    DeviceOrientation.portraitDown, // Upside-Down Portrait
  ]);
  runApp(const MyApp());
}
