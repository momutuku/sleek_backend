import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final bool rememberMe;

  LoginSubmitted(this.email, this.password, this.rememberMe);

  @override
  List<Object?> get props => [email, password, rememberMe];
}
