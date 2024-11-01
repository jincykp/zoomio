import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomer/controllers/state/theme.dart'; // Your ThemeCubit file
import 'package:zoomer/firebase_options.dart';
import 'package:zoomer/views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with BlocProvider to provide ThemeCubit
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'zoomio_userSide',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode, // Use the ThemeMode from BlocBuilder
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
