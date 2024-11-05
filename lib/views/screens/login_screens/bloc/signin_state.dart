// signin_state.dart
part of 'signin_bloc.dart';

@immutable
sealed class SigninState {}

final class SigninInitial extends SigninState {}

final class SigninLoading extends SigninState {}

final class SigninSuccess extends SigninState {}

final class SigninFailure extends SigninState {
  final String error;

  SigninFailure(this.error);

  @override
  List<Object> get props => [error];
}
