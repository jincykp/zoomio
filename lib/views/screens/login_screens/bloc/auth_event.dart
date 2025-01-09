part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailPassword({required this.email, required this.password});
}

class SignInWithGoogle extends AuthEvent {}

class CheckVerificationStatus extends AuthEvent {
  final String email;

  CheckVerificationStatus({required this.email});
}

class VerifyEmail extends AuthEvent {}

class ResendVerificationEmail extends AuthEvent {}
