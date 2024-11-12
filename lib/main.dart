import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoomer/controllers/theme.dart';
import 'package:zoomer/firebase_options.dart';
import 'package:zoomer/views/screens/splash_screen.dart';
import 'package:zoomer/views/screens/login_screens/bloc/signin_bloc.dart';
import 'package:zoomer/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with BlocProvider to provide ThemeCubit
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),

        BlocProvider(
            create: (context) =>
                SigninBloc(authServices: AuthServices())), // Provide SigninBloc
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'zoomio_userSide',
            theme: ThemeData.dark(),
            darkTheme: ThemeData.light(),
            themeMode: themeMode, // Use the ThemeMode from BlocBuilder
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
