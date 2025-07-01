import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'schedule_screen.dart';

class HistoryPetsScreen extends StatelessWidget {
  const HistoryPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Mis Mascotas'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('pets')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar mascotas'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final pets = snapshot.data!.docs;
          if (pets.isEmpty) {
            return const Center(child: Text('No hay mascotas registradas'));
          }

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final doc = pets[index];
              final data = doc.data()! as Map<String, dynamic>;
              final petId = doc.id;
              final petName = data['name'] as String? ?? 'Sin nombre';
              final petType = data['type'] as String? ?? 'Desconocido';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.pets, color: Colors.orangeAccent),
                  title: Text(
                    petName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Raza: $petType'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ScheduleScreen(
                              petId: petId,
                              petName: petName,
                              petType: petType,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => Navigator.pushNamed(context, '/add_pet'),
        child: const Icon(Icons.add),
        tooltip: 'Agregar nueva mascota',
      ),
    );
  }
}
