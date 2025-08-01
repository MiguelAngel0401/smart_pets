import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NotificationWatchScreen extends StatefulWidget {
  const NotificationWatchScreen({super.key});

  @override
  State<NotificationWatchScreen> createState() =>
      _NotificationWatchScreenState();
}

class _NotificationWatchScreenState extends State<NotificationWatchScreen> {
  final Map<String, bool> _fedStatus = {};

  bool _wasFedToday(Timestamp? timestamp) {
    if (timestamp == null) return false;
    final lastFedDate = timestamp.toDate();
    final now = DateTime.now();
    return lastFedDate.year == now.year &&
        lastFedDate.month == now.month &&
        lastFedDate.day == now.day;
  }

  Future<void> _markAsFed(String petId, bool fed) async {
    final petRef = FirebaseFirestore.instance.collection('pets').doc(petId);
    if (fed) {
      await petRef.update({'lastFedAt': FieldValue.serverTimestamp()});
    } else {
      await petRef.update({'lastFedAt': null});
    }
  }

  String _formatDateTimeToLocal(Timestamp timestamp) {
    final date = timestamp.toDate().toLocal();
    final formatter = DateFormat('hh:mm a', 'es_MX');
    return formatter.format(date);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
  }

  @override
  Widget build(BuildContext context) {
    const double fixedSize = 384;

    // Colores iguales a tu app móvil
    const Color backgroundColor = Color(0xFFFFE0B2);
    final Color appBarColor = Colors.orangeAccent.withAlpha(217);
    final Color accentColor = Colors.deepOrange.shade400;
    final Color textColor = Colors.black87;
    final Color subtitleColor = Colors.black54;
    final Color checkboxActiveColor = Colors.deepOrange;

    // Tamaños ajustados para pantalla pequeña
    const double fontSizeTitle = 12;
    const double fontSizeSubtitle = 9;
    const double iconSize = 28;
    const double checkboxSize = 22;
    const double verticalPadding = 6.0;
    const double horizontalPadding = 10.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: ClipOval(
          child: Container(
            width: fixedSize,
            height: fixedSize,
            color: backgroundColor,
            child: Column(
              children: [
                Container(
                  width: fixedSize,
                  height: fixedSize * 0.13,
                  color: appBarColor,
                  alignment: Alignment.center,
                  child: Text(
                    'Alimentar Mascotas',
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance.collection('pets').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'Sin mascotas registradas',
                              style: TextStyle(
                                color: textColor,
                                fontSize: fontSizeTitle,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final pets = snapshot.data!.docs;

                        return SingleChildScrollView(
                          child: Column(
                            children: pets.map((pet) {
                              final data = pet.data() as Map<String, dynamic>;

                              final petName = data['name'] ?? 'Mascota';
                              final Timestamp? lastFedAt = data['lastFedAt'];

                              bool fedToday =
                                  _fedStatus[pet.id] ?? _wasFedToday(lastFedAt);

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.pets,
                                      color: fedToday ? accentColor : textColor,
                                      size: iconSize,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            petName,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: fontSizeTitle,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (lastFedAt != null)
                                            Text(
                                              'Alimentado: ${_formatDateTimeToLocal(lastFedAt)}',
                                              style: TextStyle(
                                                color: subtitleColor,
                                                fontSize: fontSizeSubtitle,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: checkboxSize,
                                      height: checkboxSize,
                                      child: Checkbox(
                                        value: fedToday,
                                        activeColor: checkboxActiveColor,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        onChanged: (bool? value) async {
                                          if (value == null) return;
                                          setState(() {
                                            _fedStatus[pet.id] = value;
                                          });
                                          await _markAsFed(pet.id, value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
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
