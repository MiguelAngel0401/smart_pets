import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'services/notification_services.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// Importa tu app móvil del main.dart
import 'main.dart' as mobile_app;

// Importa la pantalla del smartwatch (debes crear este archivo y clase)
import 'screen/notification_watch_screen.dart';

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

Future<bool> isWearOS() async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    debugPrint('No es Android, es: $defaultTargetPlatform');
    return false;
  }
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  final model = androidInfo.model?.toLowerCase() ?? '';
  final manufacturer = androidInfo.manufacturer?.toLowerCase() ?? '';
  final tags = androidInfo.tags?.toLowerCase() ?? '';

  debugPrint('Device model: $model');
  debugPrint('Device manufacturer: $manufacturer');
  debugPrint('Device tags: $tags');

  final isWear = model.contains('wear') ||
      manufacturer.contains('wear') ||
      tags.contains('wear');

  debugPrint('Is WearOS? $isWear');
  return isWear;
}


class NotificationWatchApp extends StatelessWidget {
  const NotificationWatchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pets Watch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const NotificationWatchScreen(),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await NotificationService().initialize();

  final bool isWatch = await isWearOS();

  if (isWatch) {
    runApp(const NotificationWatchApp());
  } else {
    runApp(const mobile_app.MyApp());
  }
}
