import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screen/splash_screen.dart'; // ✅ Nueva pantalla
import 'screen/notification_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/session_screen.dart';
import 'screen/add_pets.dart';
import 'screen/home_screen.dart';
import 'screen/schedule_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Pets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFE0B2),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // ✅ Splash al inicio
        '/home': (context) => const HomeScreen(), // Nuevo alias para home
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/add_pet': (context) => const AddPetScreen(),
        '/session': (context) => const SessionScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/notification': (context) => const NotificationScreen(),
      },
    );
  }
}
