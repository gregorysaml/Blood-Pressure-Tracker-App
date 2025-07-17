import 'package:bloddpressuretrackerapp/bloc/login_bloc/bloc/pseudo_login_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/pseudo_login_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// navigation widget
class NavigationWidget extends StatefulWidget {
  /// constructor of the navigation widget
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PseudoLoginBloc>(
      context,
    ).add(const CheckLoginStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PseudoLoginBloc, PseudoLoginState>(
      listener: (context, state) {
        if (state.status == PseudoLoginStatus.loggedIn) {
          Navigator.pushNamed(context, '/mainpage');
        }
        if (state.status == PseudoLoginStatus.loggedOut) {
          Navigator.pushNamed(context, '/login');
        }
      },
      child: const SizedBox(),
    );
  }
}
