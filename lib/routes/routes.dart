import 'package:bloddpressuretrackerapp/bloc/login_bloc/bloc/pseudo_login_bloc.dart';
import 'package:bloddpressuretrackerapp/bloc/save_blood_pressure_bloc/save_blood_pressure_entries_bloc.dart';
import 'package:bloddpressuretrackerapp/presentation/add_mesurment_screen/add_mesurment_screen_screen.dart';
import 'package:bloddpressuretrackerapp/presentation/history_values_screen/history_values_widget.dart';
import 'package:bloddpressuretrackerapp/presentation/login_screen/login_screen.dart';
import 'package:bloddpressuretrackerapp/presentation/main_page.dart';
import 'package:bloddpressuretrackerapp/presentation/navigation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// routes
final routes = {
  '/': (_) => BlocProvider<PseudoLoginBloc>(
    create: (_) => PseudoLoginBloc(),
    child: const NavigationWidget(),
  ),
  '/login': (_) => BlocProvider<PseudoLoginBloc>(
    create: (_) => PseudoLoginBloc(),
    child: const LoginScreen(),
  ),
  '/mainpage': (_) => BlocProvider<PseudoLoginBloc>(
    create: (_) => PseudoLoginBloc(),
    child: const MainPage(),
  ),
  '/historyValues': (_) => BlocProvider<SaveBloodPressureEntriesBloc>(
    create: (_) => SaveBloodPressureEntriesBloc(),
    child: const HistoryValues(),
  ),
  '/addMesurmentScreen': (_) => BlocProvider<SaveBloodPressureEntriesBloc>(
    create: (_) => SaveBloodPressureEntriesBloc(),
    child: const AddMesurmentScreen(),
  ),
};
