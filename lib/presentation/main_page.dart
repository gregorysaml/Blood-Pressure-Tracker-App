import 'package:bloddpressuretrackerapp/bloc/login_bloc/bloc/pseudo_login_bloc.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/pseudo_login_status_enum.dart';
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
    return BlocListener<PseudoLoginBloc, PseudoLoginState>(
      listener: (context, state) {
        if (state.status == PseudoLoginStatusEnum.loggedOut) {
          Navigator.pushNamed(context, '/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Blood Pressure Tracker'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<PseudoLoginBloc>(
                  context,
                ).add(const PseudoSignOutEvent());
              },
            ),
          ],
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
      ),
    );
  }
}
