// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:bloddpressuretrackerapp/enums/pseudo_login_status_enum.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pseudo_login_event.dart';
part 'pseudo_login_state.dart';

/// pseudo login bloc
class PseudoLoginBloc extends Bloc<PseudoLoginEvent, PseudoLoginState> {
  /// constructor of the pseudo login bloc
  PseudoLoginBloc() : super(const PseudoLoginState()) {
    on<PseudoSignInEvent>((event, emit) async {
      logger.i('Login pressed ${event.username} ${event.password}');
      final prefs = await SharedPreferences.getInstance();
      emit(state.copyWith(status: PseudoLoginStatusEnum.loggingIn));
      if (event.username.isEmpty || event.password.isEmpty) {
        emit(state.copyWith(status: PseudoLoginStatusEnum.error));

        return;
      }
      if (event.username == 'admin' && event.password == 'admin') {
        await prefs.setBool('isLogged', true);
        emit(state.copyWith(status: PseudoLoginStatusEnum.loggedIn));
      } else {
        emit(state.copyWith(status: PseudoLoginStatusEnum.loggedOut));
      }
    });
    on<CheckLoginStatusEvent>((_, emit) async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('isLogged') ?? false) {
        emit(state.copyWith(status: PseudoLoginStatusEnum.loggedIn));
      } else {
        emit(state.copyWith(status: PseudoLoginStatusEnum.loggedOut));
      }
    });
    on<PseudoSignOutEvent>((_, emit) async {
      emit(state.copyWith(status: PseudoLoginStatusEnum.loggingIn));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogged', false);
      emit(state.copyWith(status: PseudoLoginStatusEnum.loggedOut));
    });
  }
}
