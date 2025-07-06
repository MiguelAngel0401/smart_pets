import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String? actionId;

  const NotificationScreen({super.key, this.actionId});

  @override
  Widget build(BuildContext context) {
    final isFeed = actionId == 'feed_now';
    final title =
        isFeed ? '¡Tu mascota te lo agradece! 🐾' : '¿Necesitas ayuda?';
    final message =
        isFeed
            ? 'Has confirmado la rutina de alimentación.'
            : 'Puedes contactar a soporte o revisar la rutina programada.';

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0B2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isFeed ? Icons.pets : Icons.help_outline,
                size: 64,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
