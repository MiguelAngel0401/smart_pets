import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.width < 300;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0B2),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Configurar Horario'),
        backgroundColor: Colors.orangeAccent.withAlpha(230),
        elevation: 0,
        toolbarHeight: 70,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(242),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.orangeAccent.withAlpha(77),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Aquí puedes configurar el horario de tu mascota',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 30,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Seleccionar Hora',
                        style: TextStyle(
                          fontSize: isSmallDevice ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        selectedDate != null
                            ? "${selectedDate!.day.toString().padLeft(2, '0')}/"
                                "${selectedDate!.month.toString().padLeft(2, '0')}/"
                                "${selectedDate!.year}"
                            : 'Seleccionar Fecha',
                        style: TextStyle(
                          fontSize: isSmallDevice ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 140,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción al guardar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43A047),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 6,
                      shadowColor: Colors.green.withOpacity(0.4),
                    ),
                    child: const Center(
                      child: Text(
                        'Guardar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Smart Pets ❤️ Cuidando a quienes más amas',
                  style: TextStyle(
                    fontSize: 14,
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
    );
  }
}
