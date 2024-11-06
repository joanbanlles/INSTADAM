import 'package:flutter/material.dart';
import 'package:instadam/home.dart';
import 'package:instadam/profile.dart'; // Importa SettingsScreen
// Importa LoginScreen
import 'barra_navegacion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instadam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Cambia la pantalla inicial a LoginScreen
      routes: {
        '/profile': (context) => const ProfileScreen(),
        '/barranavegacio': (context) => const BarraNavegacion(),
      },
    );
  }
}
