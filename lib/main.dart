import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screen/splash_screen.dart';
import 'screen/notification_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/session_screen.dart';
import 'screen/add_pets.dart';
import 'screen/home_screen.dart';
import 'screen/schedule_screen.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ✅ Controlador global para navegación desde notificaciones
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // ✅ Manejador para cuando se toca la notificación
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      navigatorKey.currentState?.pushNamed('/notification');
    },
  );
}

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
  await initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // ✅ Conecta la navegación
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
