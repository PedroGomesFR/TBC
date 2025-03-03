import 'package:flutter/material.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Suivi des rendez-vous médicaux',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
