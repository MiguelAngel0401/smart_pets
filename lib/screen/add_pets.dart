import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _customTypeController = TextEditingController();
  String? _selectedType;
  bool _showCustomType = false;

  bool _isSaving = false;

  // Lista ampliada de tipos de mascotas
  final List<String> _petTypes = [
    'Perro',
    'Gato',
    'Pájaro',
    'Pez',
    'Conejo',
    'Hámster',
    'Tortuga',
    'Iguana',
    'Serpiente',
    'Chinchilla',
    'Cobaya',
    'Hurón',
    'Otro',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _customTypeController.dispose();
    super.dispose();
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate() || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Validar si seleccionó "Otro" pero no escribió el tipo personalizado
    if (_selectedType == 'Otro' && _customTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, especifica el tipo de mascota'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay usuario autenticado')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Determinar el tipo final a guardar
      String finalType =
          _selectedType == 'Otro'
              ? _customTypeController.text.trim()
              : _selectedType!;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('pets')
          .add({
            'name': _nameController.text.trim(),
            'age': int.parse(_ageController.text.trim()),
            'type': finalType,
            'createdAt': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mascota guardada con éxito')),
      );

      _nameController.clear();
      _ageController.clear();
      _customTypeController.clear();
      setState(() {
        _selectedType = null;
        _showCustomType = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

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
              child: Form(
                key: _formKey,
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
                      controller: _nameController,
                      label: 'Nombre de la mascota',
                      icon: Icons.pets,
                      isSmall: isSmallDevice,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: _ageController,
                      label: 'Edad',
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      isSmall: isSmallDevice,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa la edad';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 0) {
                          return 'Ingresa una edad válida';
                        }
                        return null;
                      },
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
                          _petTypes
                              .map(
                                (tipo) => DropdownMenuItem(
                                  value: tipo,
                                  child: Text(tipo),
                                ),
                              )
                              .toList(),
                      value: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                          _showCustomType = value == 'Otro';
                          if (value != 'Otro') {
                            _customTypeController.clear();
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona un tipo';
                        }
                        return null;
                      },
                    ),

                    // Campo de texto personalizado que aparece cuando se selecciona "Otro"
                    if (_showCustomType) ...[
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _customTypeController,
                        label: 'Especifica el tipo de mascota',
                        icon: Icons.edit,
                        isSmall: isSmallDevice,
                        validator: (value) {
                          if (_selectedType == 'Otro' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Por favor especifica el tipo de mascota';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _isSaving ? null : _savePet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isSaving
                                ? Colors.orangeAccent.withAlpha(120)
                                : Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                              : Text(
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
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool isSmall = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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
      validator: validator,
    );
  }
}
