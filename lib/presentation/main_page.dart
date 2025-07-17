import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/presentation/blood_pressure_widget/blood_pressure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// main page widget
class MainPage extends StatefulWidget {
  /// constructor of the main page

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Blood Pressure Tracker'),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          BlocProvider(
            create: (_) => SaveBloodPressureEntriesBloc(),
            child: const BloodPressureWidget(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(children: [Icon(Icons.add)]),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/addMesurmentScreen');
            },
          ),
          SizedBox(height: 1.h),
          Text('Add Measurement', style: TextStyle(fontSize: 16.sp)),
        ],
      ),
    );
  }
}
