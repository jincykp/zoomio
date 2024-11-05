// signin_event.dart
part of 'signin_bloc.dart';

@immutable
sealed class SigninEvent {}

class LoginSubmitted extends SigninEvent {
  final String email;
  final String password;

  LoginSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
