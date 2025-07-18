part of 'pseudo_login_bloc.dart';

/// pseudo login state
final class PseudoLoginState extends Equatable {
  /// Query Status
  final PseudoLoginStatusEnum status;

  @override
  List<Object> get props => [status];

  /// intial State
  const PseudoLoginState({this.status = PseudoLoginStatusEnum.loggedOut});

  /// Readable copy of ExtensionsState to push
  PseudoLoginState copyWith({PseudoLoginStatusEnum? status}) {
    return PseudoLoginState(status: status ?? this.status);
  }

  @override
  String toString() {
    return 'PseudoLoginState{status: $status}';
  }
}
