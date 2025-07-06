import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Inicializar timezone
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    // Configuración del canal de notificaciones
    const channel = AndroidNotificationChannel(
      'smart_pets_channel',
      'Smart Pets Notifications',
      description: 'Canal para notificaciones de alimentación de mascotas',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    final androidImpl =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImpl?.createNotificationChannel(channel);

    // Solicitar permisos de notificación
    await _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (result.isDenied) {
        print('❌ Permisos de notificación denegados');
      } else {
        print('✅ Permisos de notificación concedidos');
      }
    }
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'smart_pets_channel',
      'Smart Pets Notifications',
      channelDescription:
          'Canal para notificaciones de alimentación de mascotas',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id, title, body, details);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      // Verificar que la fecha sea futura
      if (scheduledDate.isBefore(DateTime.now())) {
        print('❌ Error: La fecha programada debe ser futura');
        return;
      }

      // Convertir a timezone local
      final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

      print('✅ Programando notificación para: $tzScheduled');

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'smart_pets_channel',
            'Smart Pets Notifications',
            channelDescription:
                'Canal para notificaciones de alimentación de mascotas',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            fullScreenIntent: true, // Mostrar en pantalla completa
            category: AndroidNotificationCategory.reminder,
            showWhen: true,
            when: null, // Usar hora programada
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      print('✅ Notificación programada exitosamente con ID: $id');
    } catch (e) {
      print('❌ Error al programar notificación: $e');
    }
  }

  // Método para cancelar notificación específica
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print('✅ Notificación cancelada con ID: $id');
  }

  // Método para cancelar todas las notificaciones
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    print('✅ Todas las notificaciones canceladas');
  }

  // Método para obtener notificaciones pendientes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    print('📋 Notificaciones pendientes: ${pending.length}');
    return pending;
  }

  // Método para mostrar notificación inmediata (útil para pruebas)
  Future<void> showTestNotification() async {
    await show(
      id: 999999,
      title: '🐾 Prueba de Notificación',
      body: 'Las notificaciones están funcionando correctamente',
    );
  }
}
