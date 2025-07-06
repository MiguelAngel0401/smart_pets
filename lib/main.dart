import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// Pantallas
import 'screen/splash_screen.dart';
import 'screen/notification_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/session_screen.dart';
import 'screen/add_pets.dart';
import 'screen/home_screen.dart';
import 'screen/schedule_screen.dart';

// Servicio de notificaciones
import 'services/notification_services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
    );
    debugPrint("✅ Conexión a Firebase exitosa");
  } catch (e) {
    debugPrint("❌ Error al conectar con Firebase: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await NotificationService()
      .initialize(); // 🔔 Inicializa servicio de notificaciones
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Smart Pets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFE0B2),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/add_pet': (context) => const AddPetScreen(),
        '/session': (context) => const SessionScreen(nickname: ''),
        '/schedule':
            (context) =>
                const ScheduleScreen(petName: '', petType: '', petId: ''),
        '/notification': (context) => const NotificationScreen(),
      },
    );
  }
}
