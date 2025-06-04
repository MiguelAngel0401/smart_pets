import 'package:flutter/material.dart';
import 'package:smart_pets/screen/schedule_screen.dart';
import 'package:smart_pets/screen/add_pets.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0B2),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bienvenido Miguel',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.orangeAccent.withAlpha(217),
        elevation: 4,
        shadowColor: Colors.orange.shade200.withAlpha(102),

        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 6,
                shadowColor: Colors.deepOrange.withAlpha(38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 25,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '¡Hora de alimentar a tus mascotas!',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade400.withAlpha(204),
                          fontFamily: 'Georgia',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      _responsiveButton(
                        context,
                        "Agregar Mascota",
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPetScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _responsiveButton(
                        context,
                        "Configurar alimentación",
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScheduleScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _responsiveButton(context, "Historial de Mascotas", () {
                        // Acción para historial
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(38),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withAlpha(26),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.logout, color: Colors.redAccent, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Smart Pets ❤️ Cuidando a quienes más amas',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _responsiveButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange.withAlpha(217),
        minimumSize: Size(screenWidth * 0.7, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
        shadowColor: Colors.deepOrangeAccent.withAlpha(77),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
