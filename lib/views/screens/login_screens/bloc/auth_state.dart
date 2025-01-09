part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String email;
  final String? displayName;

  AuthSuccess({required this.email, this.displayName});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class EmailVerificationSent extends AuthState {
  final String email;
  EmailVerificationSent({required this.email});
}

class VerificationEmailResent extends AuthState {
  final String message;
  VerificationEmailResent(
      {this.message = 'Verification email resent successfully!'});
}

class EmailVerified extends AuthState {}
