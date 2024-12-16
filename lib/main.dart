import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  requestNotificationPermission();

  // Initialize PriceServices here
  final priceServices =
      PriceServices(); // Initialize priceServices before passing it

  runApp(MyApp());
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permission for iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("Notification permission granted");
  } else {
    print("Notification permission denied");
  }
} // Pass priceServices to MyApp

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // You can perform background processing or notification handling here
}

Future<void> getFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();

  if (token != null) {
    print("FCM Token: $token");
  } else {
    print("Failed to get FCM Token");
  }
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
