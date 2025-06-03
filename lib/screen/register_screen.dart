import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0B2),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Registro',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width > 600 ? 500 : width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.pets, size: 60, color: Colors.deepOrange),
                const SizedBox(height: 20),
                const Text(
                  'Crea tu cuenta Smart Pets 🐾',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                    color: Colors.deepOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Completa los datos para comenzar',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                _buildInputField(label: 'Nombre'),
                _buildInputField(label: 'Nickname'),
                _buildInputField(label: 'Correo'),
                _buildInputField(label: 'Contraseña', obscure: true),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Aquí tu lógica de registro
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 8), // Espacio reducido
                TextButton(
                  onPressed: () {
                    // Lógica para Términos y Condiciones
                  },
                  child: const Text(
                    'Términos y Condiciones',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 12), // Espacio reducido
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes una cuenta? ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Iniciar Sesión aquí',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
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
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: _getIconForLabel(label),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Icon? _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'nombre':
        return const Icon(Icons.person_outline);
      case 'nickname':
        return const Icon(Icons.person);
      case 'correo':
        return const Icon(Icons.email_outlined);
      case 'contraseña':
        return const Icon(Icons.lock_outline);
      default:
        return null;
    }
  }
}
