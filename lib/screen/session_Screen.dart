import 'package:flutter/material.dart';
import 'package:smart_pets/screen/schedule_screen.dart';
import 'package:smart_pets/screen/add_pets.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        //double screenHeight = constraints.maxHeight;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Bienvenido Miguel'),
            backgroundColor: Colors.orangeAccent,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '¡Hora de alimentar a tus mascotas!',
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
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
                          _responsiveButton(
                            context,
                            "Historial de Mascotas",
                            () {
                              // Acción para historial
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                    const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _responsiveButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        minimumSize: Size(screenWidth * 0.7, 50),
      ),
      child: Text(text),
    );
  }
}
