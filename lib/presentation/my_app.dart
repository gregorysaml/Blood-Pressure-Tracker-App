import 'package:bloddpressuretrackerapp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// material widget
class MyApp extends StatelessWidget {
  /// contastructor
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, __, ___) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 39, 179, 46),
              brightness: Brightness.dark,
            ),
          ),
          routes: routes,
          initialRoute: '/',
        );
      },
    );
  }
}
