part of 'pseudo_login_bloc.dart';

sealed class PseudoLoginState extends Equatable {
  const PseudoLoginState();
  
  @override
  List<Object> get props => [];
}

final class PseudoLoginInitial extends PseudoLoginState {}
