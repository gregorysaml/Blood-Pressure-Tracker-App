import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pseudo_login_event.dart';
part 'pseudo_login_state.dart';
/// pseudo login bloc
class PseudoLoginBloc extends Bloc<PseudoLoginEvent, PseudoLoginState> {
  PseudoLoginBloc() : super(PseudoLoginInitial()) {
    on<PseudoLoginEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
