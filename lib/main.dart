import 'package:flutter/material.dart';
import 'package:smart_pets/screen/notification_Screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/session_screen.dart';
import 'screen/add_pets.dart';
import 'screen/homescreen.dart';
import 'screen/schedule_screen.dart';

void main() {
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
        '/': (context) => const HomeScreen(),
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
