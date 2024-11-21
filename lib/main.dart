import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomer/controllers/theme.dart';
import 'package:zoomer/firebase_options.dart';
import 'package:zoomer/views/screens/splash_screen.dart';
import 'package:zoomer/views/screens/login_screens/bloc/signin_bloc.dart';
import 'package:zoomer/services/auth_services.dart';
import 'package:zoomer/views/screens/where_to_go_screens/bloc/vehicle_bloc.dart';
import 'package:zoomer/views/screens/where_to_go_screens/price_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize PriceServices here
  final priceServices =
      PriceServices(); // Initialize priceServices before passing it

  runApp(MyApp()); // Pass priceServices to MyApp
}

class MyApp extends StatelessWidget {
  // Declare priceServices

  const MyApp({
    super.key,
  }); // Accept priceServices in constructor

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with BlocProvider to provide ThemeCubit
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
            create: (context) => SigninBloc(authServices: AuthServices())),
        BlocProvider(
          create: (context) => VehicleBloc(PriceServices()),
        ) // Pass priceServices to VehicleBloc
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
