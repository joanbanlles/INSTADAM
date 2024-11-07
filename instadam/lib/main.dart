import 'package:flutter/material.dart';
import 'package:instadam/home.dart';
import 'package:instadam/profile.dart';
import 'package:instadam/login.dart'; // Verifica que login.dart contiene LoginScreen
import 'package:instadam/settings.dart';
import 'package:instadam/barra_navegacion.dart';
import 'package:instadam/signup.dart'; // Importa la pantalla de registro

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
      // Cambiamos la pantalla de inicio a SignUp
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignUp(),            // Ruta para registro
        '/login': (context) => const LoginScreen(),        // Ruta para LoginScreen, no login
        '/home': (context) => const HomeScreen(),          // Ruta para Home
        '/profile': (context) => const ProfileScreen(),    // Ruta para Perfil
        '/settings': (context) => const Settings(),        // Ruta para Ajustes
        '/barranavegacion': (context) => const BarraNavegacion(), // Barra de Navegación
      },
    );
  }
}
