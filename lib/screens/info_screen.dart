import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Informations et conseils',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
