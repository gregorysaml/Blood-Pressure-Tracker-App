part of 'pseudo_login_bloc.dart';

/// pseudo login state
final class PseudoLoginState extends Equatable {
  /// Query Status
  final PseudoLoginStatus status;

  @override
  List<Object> get props => [status];

  /// intial State
  const PseudoLoginState({this.status = PseudoLoginStatus.loggedOut});

  /// Readable copy of ExtensionsState to push
  PseudoLoginState copyWith({PseudoLoginStatus? status}) {
    return PseudoLoginState(status: status ?? this.status);
  }

  @override
  String toString() {
    return 'PseudoLoginState{status: $status}';
  }
}
