import 'package:flutter/material.dart';

import 'sign_up.dart';
import 'login.dart';

import 'package:instadam/home.dart';
import 'package:instadam/Profile.dart';
import 'package:instadam/settings.dart';
import 'package:instadam/newpost.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'App de Ejemplo',
      initialRoute: '/signup',  // Cambia a la pantalla de registro por defecto
      routes: {
        '/signup': (context) => const SignUp(), // Cambia SignUpScreen a SignUp
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),

      debugShowMaterialGrid: false,
      title: 'Flutter Navigation',
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/settings': (context) => Settings(),
        '/newpost': (context) => Newpost(),

      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Home(),
    ProfileScreen(),
    Settings(),
    Newpost(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'NewPost',
          ),
        ],
      ),
    );
  }
}
