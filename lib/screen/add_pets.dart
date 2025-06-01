import 'package:flutter/material.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho y alto de la pantalla
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.width < 300; // Umbral para smartwatch

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Registra Nueva Mascota',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.orangeAccent,
        toolbarHeight:
            isSmallDevice ? 40 : 56, // AppBar más compacto en smartwatch
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la mascota',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: isSmallDevice ? 12 : 14),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Edad',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: isSmallDevice ? 12 : 14),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de mascota',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Gato', 'Perro', 'Otro']
                          .map(
                            (tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(
                                tipo,
                                style: TextStyle(
                                  fontSize: isSmallDevice ? 12 : 14,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    child: Text(
                      'Guardar Mascota',
                      style: TextStyle(fontSize: isSmallDevice ? 12 : 14),
                    ),
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

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AddPetScreen()),
  );
}
