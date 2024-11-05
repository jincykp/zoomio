// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:zoomer/services/auth_services.dart';
// import 'package:zoomer/services/userservices.dart';
// import 'package:zoomer/views/screens/login_screens/bloc/signup_event.dart';

// class SignupBloc extends Bloc<SignupEvent, SignupState> {
//   final AuthServices authService;
//   final UserService userService;

//   SignupBloc(this.authService, this.userService) : super(SignupInitial()) {
//     on<SignupWithEmailPassword>(_onSignupWithEmailPassword);
//     on<SignupWithGoogle>(_onSignupWithGoogle);
//     on<NavigateToSignIn>(_onNavigateToSignIn);
//   }

//   // Handle sign-up with email and password
//   Future<void> _onSignupWithEmailPassword(
//     SignupWithEmailPassword event,
//     Emitter<SignupState> emit,
//   ) async {
//     emit(SignupLoading());
//     try {
//       // Sign up using AuthServices
//       User? user = await authService.createAccountWithEmail(
//         event.email,
//         event.password,
//       );

//       if (user != null) {
//         // Save user details to Firestore
//         await userService.saveUserDetails(user.uid, event.email, "");
//         emit(SignupSuccess(event.email));
//       } else {
//         emit(SignupFailure("Sign-up failed, please try again."));
//       }
//     } catch (e) {
//       emit(SignupFailure(e.toString()));
//     }
//   }

//   // Handle Google Sign-In
//   Future<void> _onSignupWithGoogle(
//     SignupWithGoogle event,
//     Emitter<SignupState> emit,
//   ) async {
//     emit(SignupLoading());
//     try {
//       User? user = await authService.signInWithGoogle();
//       if (user != null) {
//         emit(SignupSuccess(user.email ?? ""));
//       } else {
//         emit(SignupFailure("Google Sign-In failed, please try again."));
//       }
//     } catch (e) {
//       emit(SignupFailure(e.toString()));
//     }
//   }

//   // Navigate to Sign-In screen
//   void _onNavigateToSignIn(
//     NavigateToSignIn event,
//     Emitter<SignupState> emit,
//   ) {
//     emit(SignInNavigationState());
//   }
// }
