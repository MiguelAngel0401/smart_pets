import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmartwatch = screenWidth < 300;

    final exampleTime = "08:00 AM";
    final exampleDate = "26 de mayo de 2025";

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFCC80)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmartwatch ? 12 : 20,
              vertical: isSmartwatch ? 16 : 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pets,
                  size: isSmartwatch ? 40 : 60,
                  color: Colors.orange[700],
                ),
                const SizedBox(height: 12),
                Text(
                  '¡Es hora de alimentar\na tu mascota!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmartwatch ? 14 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[900],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '⏰ $exampleTime',
                  style: TextStyle(
                    fontSize: isSmartwatch ? 12 : 16,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '📅 $exampleDate',
                  style: TextStyle(
                    fontSize: isSmartwatch ? 12 : 16,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
