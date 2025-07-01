import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class ScheduleScreen extends StatefulWidget {
  final String petId;
  final String petName;
  final String petType;

  const ScheduleScreen({
    super.key,
    required this.petId,
    required this.petName,
    required this.petType,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  bool _isSaving = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Mexico_City'));

    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final initSettings = InitializationSettings(android: androidInitSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings);

    _createNotificationChannel();
    _requestNotificationPermission();
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'smart_pets_channel',
      'Smart Pets Notifications',
      description: 'Canal para notificaciones de alimentación',
      importance: Importance.high,
    );

    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.createNotificationChannel(channel);
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        if (!result.isGranted && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permiso para notificaciones no concedido'),
            ),
          );
        }
      }
    }
  }

  Future<void> _scheduleNotification(DateTime scheduledDate) async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) return;
    }

    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);
    final id = scheduledDate.hashCode & 0x7FFFFFFF;

    const androidDetails = AndroidNotificationDetails(
      'smart_pets_channel',
      'Smart Pets Notifications',
      channelDescription: 'Canal para notificaciones de alimentación',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Hora de alimentar a ${widget.petName}',
      'No olvides darle de comer a tu mascota.',
      tzScheduled,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: false,
      matchDateTimeComponents: null,
      androidScheduleMode:
          AndroidScheduleMode
              .inexactAllowWhileIdle, // 👈 Esto lo hace compatible
    );
  }

  Future<void> _selectDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _saveSchedule() async {
    final messenger = ScaffoldMessenger.of(context);

    if (_selectedDate == null || _selectedTime == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Selecciona fecha y hora')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final scheduledAt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (scheduledAt.isBefore(DateTime.now())) {
      messenger.showSnackBar(
        const SnackBar(content: Text('La fecha y hora deben ser futuras')),
      );
      setState(() => _isSaving = false);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.petId)
          .collection('schedules')
          .add({
            'scheduledAt': scheduledAt,
            'createdAt': FieldValue.serverTimestamp(),
          });

      await _scheduleNotification(scheduledAt);

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Horario guardado. Notificación programada para las ${_selectedTime!.format(context)}',
          ),
        ),
      );

      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 350;
    final labelStyle = TextStyle(
      fontSize: isSmall ? 16 : 18,
      color: Colors.black54,
    );
    final valueStyle = TextStyle(
      fontSize: isSmall ? 18 : 20,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0B2),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.petName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.pets, size: 32, color: Colors.deepOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.petName, style: valueStyle),
                          const SizedBox(height: 4),
                          Text(widget.petType, style: labelStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Fecha', style: labelStyle),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _selectDate,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepOrange.shade100),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _selectedDate == null
                    ? 'Seleccionar Fecha'
                    : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                style: valueStyle,
              ),
            ),
            const SizedBox(height: 16),
            Text('Hora', style: labelStyle),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _selectTime,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepOrange.shade100),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _selectedTime?.format(context) ?? 'Seleccionar Hora',
                style: valueStyle,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  _isSaving
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        'Guardar Horario',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
