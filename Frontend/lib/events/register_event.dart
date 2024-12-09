import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String address;
  final String password;
  final String confirmPassword;

  RegisterSubmitted({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, firstName, lastName, address, password, confirmPassword];
}
