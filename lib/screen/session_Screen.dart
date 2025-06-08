import 'package:flutter/material.dart';
import 'package:smart_pets/screen/schedule_screen.dart';
import 'package:smart_pets/screen/add_pets.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double clamp(double val, double min, double max) => val.clamp(min, max);

    final double maxCardWidth = 500;

    final double cardWidth =
        screenWidth < maxCardWidth ? screenWidth * 0.9 : maxCardWidth;
    final double fontSizeTitle = clamp(screenWidth * 0.05, 18, 28);
    final double fontSizeButton = clamp(screenWidth * 0.04, 14, 20);
    final double buttonWidth = clamp(screenWidth * 0.7, 220, 350);
    final double verticalPadding = clamp(screenHeight * 0.02, 15, 40);

    final double logoutIconSize = clamp(screenWidth * 0.05, 18, 28);
    final double logoutFontSize = clamp(screenWidth * 0.035, 14, 20);
    final double logoutHorizontalPadding = clamp(screenWidth * 0.08, 20, 40);
    final double logoutVerticalPadding = clamp(screenHeight * 0.015, 8, 15);

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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 6,
                shadowColor: Colors.deepOrange.withAlpha(38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.zero,
                child: Container(
                  width: cardWidth,
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding * 1.5,
                    horizontal: cardWidth * 0.08,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '¡Hora de alimentar a tus mascotas!',
                        style: TextStyle(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade400.withAlpha(204),
                          fontFamily: 'Georgia',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: verticalPadding * 1.8),
                      _responsiveButton(
                        context,
                        "Agregar Mascota",
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPetScreen(),
                          ),
                        ),
                        buttonWidth,
                        fontSizeButton,
                      ),
                      SizedBox(height: verticalPadding),
                      _responsiveButton(
                        context,
                        "Configurar alimentación",
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScheduleScreen(),
                          ),
                        ),
                        buttonWidth,
                        fontSizeButton,
                      ),
                      SizedBox(height: verticalPadding),
                      _responsiveButton(
                        context,
                        "Historial de Mascotas",
                        () {
                          // Acción para historial
                        },
                        buttonWidth,
                        fontSizeButton,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: verticalPadding * 2),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: logoutVerticalPadding,
                    horizontal: logoutHorizontalPadding,
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
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                        size: logoutIconSize,
                      ),
                      SizedBox(width: logoutHorizontalPadding * 0.3),
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          fontSize: logoutFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: verticalPadding * 3),
              Center(
                child: Text(
                  'Smart Pets ❤️ Cuidando a quienes más amas',
                  style: TextStyle(
                    fontSize: clamp(screenWidth * 0.035, 12, 18),
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _responsiveButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    double width,
    double fontSize,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange.withAlpha(217),
        minimumSize: Size(width, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
        shadowColor: Colors.deepOrangeAccent.withAlpha(77),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
