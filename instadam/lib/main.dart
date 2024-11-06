import 'package:flutter/material.dart';
import 'package:instadam/home.dart';
import 'package:instadam/profile.dart';
import 'package:instadam/login.dart';
import 'package:instadam/settings.dart';
import 'barra_navegacion.dart';

void main() {
  runApp(MyApp());
}

void runApp(MyApp myApp) {
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instadam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), // Cambia la pantalla inicial a LoginScreen
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const Settings(),
        '/barranavegacio': (context) => const BarraNavegacion(),
      },
    );
  }
}
