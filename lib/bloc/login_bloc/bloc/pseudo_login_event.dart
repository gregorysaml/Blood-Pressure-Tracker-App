part of 'pseudo_login_bloc.dart';

/// pseudo login event
sealed class PseudoLoginEvent extends Equatable {
  @override
  List<Object> get props => [];
  const PseudoLoginEvent();
}

/// pseudo login event
class PseudoSignInEvent extends PseudoLoginEvent {
  /// username
  final String username;

  /// password
  final String password;

  /// constructor of the pseudo sign in event
  const PseudoSignInEvent({required this.username, required this.password});
}

/// pseudo login event
class CheckLoginStatusEvent extends PseudoLoginEvent {
  /// constructor of the check login status event
  const CheckLoginStatusEvent();
}

/// pseudo login event
class PseudoSignOutEvent extends PseudoLoginEvent {
  /// constructor of the pseudo sign out event
  const PseudoSignOutEvent();
}
