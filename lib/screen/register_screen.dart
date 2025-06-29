import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    _nicknameController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showMessage(String title, String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      await _showMessage(
        'Error',
        'Por favor completa todos los campos correctamente',
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _correoController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('No se pudo obtener el UID del usuario.');
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'nombre': _nombreController.text.trim(),
        'nickname': _nicknameController.text.trim(),
        'email': _correoController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _showMessage('¡Éxito!', 'Usuario registrado correctamente');

      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String mensaje = 'Error al registrar usuario';
      if (e.code == 'email-already-in-use') {
        mensaje = 'El correo ya está en uso.';
      } else if (e.code == 'weak-password') {
        mensaje = 'La contraseña es muy débil.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'Correo no válido.';
      }
      await _showMessage('Error', mensaje);
    } catch (e) {
      await _showMessage('Error inesperado', e.toString());
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width > 600 ? 500 : width),
            child: Form(
              key: _formKey,
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
                  _buildInputField(
                    controller: _nombreController,
                    label: 'Nombre',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  _buildInputField(
                    controller: _nicknameController,
                    label: 'Nickname',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El nickname es obligatorio';
                      }
                      return null;
                    },
                  ),
                  _buildInputField(
                    controller: _correoController,
                    label: 'Correo',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El correo es obligatorio';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    obscure: true,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'La contraseña es obligatoria';
                      }
                      if (v.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _register,
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
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Aquí tu lógica para Términos y Condiciones
                    },
                    child: const Text(
                      'Términos y Condiciones',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
      ),
    );
  }
}
