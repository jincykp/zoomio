// signin_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zoomer/services/auth_services.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthServices authServices;

  SigninBloc({required this.authServices}) : super(SigninInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(
      LoginSubmitted event, Emitter<SigninState> emit) async {
    emit(SigninLoading());

    try {
      // Attempt to log in using the AuthServices
      final user = await authServices.loginAccountWithEmail(
        event.email.trim(),
        event.password.trim(),
      );

      if (user != null) {
        emit(SigninSuccess());
      } else {
        emit(SigninFailure('Invalid email or password.'));
      }
    } catch (error) {
      emit(SigninFailure(error.toString()));
    }
  }
}
