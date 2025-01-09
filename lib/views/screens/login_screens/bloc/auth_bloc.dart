import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/services/userservices.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices _authServices;
  final UserService _userService;
  final FirebaseAuth _auth;

  AuthBloc({
    required AuthServices authServices,
    required UserService userService,
  })  : _authServices = authServices,
        _userService = userService,
        _auth = FirebaseAuth.instance,
        super(AuthInitial()) {
    on<SignUpWithEmailPassword>(_handleSignUpWithEmailPassword);
    on<SignInWithGoogle>(_handleSignInWithGoogle);
    on<CheckVerificationStatus>(_handleCheckVerificationStatus);
    on<ResendVerificationEmail>(_handleResendVerificationEmail);
    on<VerifyEmail>(_handleVerifyEmail);
  }

  Future<void> _handleSignUpWithEmailPassword(
    SignUpWithEmailPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authServices.createAccountWithEmail(
        event.email,
        event.password,
        "",
      );

      if (user != null) {
        await _userService.saveUserDetails(
          user.uid,
          event.email,
          "",
        );
        emit(EmailVerificationSent(email: event.email));
      } else {
        emit(AuthError(message: 'Failed to create account'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _handleSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          await _userService.saveUserDetails(
            user.uid,
            googleUser.email,
            googleUser.displayName ?? "",
          );
          emit(AuthSuccess(
            email: googleUser.email,
            displayName: googleUser.displayName,
          ));
        }
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _handleCheckVerificationStatus(
    CheckVerificationStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();

      if (user?.emailVerified ?? false) {
        emit(AuthSuccess(email: event.email));
      } else {
        emit(AuthError(message: 'Email not verified'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _handleResendVerificationEmail(
    ResendVerificationEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _authServices.sendEmailVerification(user);
        emit(VerificationEmailResent());
      } else {
        emit(AuthError(message: 'No user found'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _handleVerifyEmail(
    VerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          emit(EmailVerified());
        } else {
          emit(AuthError(message: 'Email not verified yet'));
        }
      } else {
        emit(AuthError(message: 'No user found'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
