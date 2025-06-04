import 'package:flutter/material.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallDevice = width < 300;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0B2),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Registra Nueva Mascota',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: isSmallDevice ? 50 : 70,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Color(0xFFFFB74D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width > 600 ? 500 : width),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(235),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withAlpha(77),

                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Agrega aquí tu mascota',
                    style: TextStyle(
                      fontSize: isSmallDevice ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  _buildInputField(
                    label: 'Nombre de la mascota',
                    icon: Icons.pets,
                    isSmall: isSmallDevice,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'Edad',
                    icon: Icons.cake,
                    keyboardType: TextInputType.number,
                    isSmall: isSmallDevice,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de mascota',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                      filled: true,
                      fillColor: Colors.orangeAccent.withAlpha(26),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.orangeAccent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items:
                        ['Gato', 'Perro', 'Otro']
                            .map(
                              (tipo) => DropdownMenuItem(
                                value: tipo,
                                child: Text(tipo),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Guardar Mascota',
                      style: TextStyle(
                        fontSize: isSmallDevice ? 14 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    'Smart Pets ❤️ Cuidando a quienes más amas',
                    style: TextStyle(
                      fontSize: isSmallDevice ? 14 : 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool isSmall = false,
  }) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(fontSize: isSmall ? 14 : 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            icon != null ? Icon(icon, color: Colors.orangeAccent) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.orangeAccent.withAlpha(26),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AddPetScreen()),
  );
}
