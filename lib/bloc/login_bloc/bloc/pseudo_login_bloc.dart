import 'package:bloc/bloc.dart';
import 'package:bloddpressuretrackerapp/enums/pseudo_login_status_enum.dart';
import 'package:equatable/equatable.dart';

part 'pseudo_login_event.dart';
part 'pseudo_login_state.dart';

/// pseudo login bloc
class PseudoLoginBloc extends Bloc<PseudoLoginEvent, PseudoLoginState> {
  PseudoLoginBloc() : super(const PseudoLoginState()) {
    on<PseudoSignInEvent>((event, emit) async {
      emit(state.copyWith(status: PseudoLoginStatus.loggingIn));
      if (event.username.isEmpty || event.password.isEmpty) {
        emit(state.copyWith(status: PseudoLoginStatus.error));

        return;
      }
      if (event.username == 'admin' && event.password == 'admin') {
        emit(state.copyWith(status: PseudoLoginStatus.loggedIn));
      } else {
        emit(state.copyWith(status: PseudoLoginStatus.error));
      }
    });
    on<CheckLoginStatusEvent>((event, emit) {
      emit(state.copyWith(status: PseudoLoginStatus.loggingIn));
      emit(state.copyWith(status: PseudoLoginStatus.loggedOut));
    });
    on<PseudoSignOutEvent>((event, emit) {
      emit(state.copyWith(status: PseudoLoginStatus.loggedOut));
    });
  }
}
