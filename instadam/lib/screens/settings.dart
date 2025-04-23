import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _saveLoginData = false;
  String _accountName = '';

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  void _loadAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _saveLoginData = prefs.getBool('saveLoginData') ?? false;
      _accountName = prefs.getString('accountName') ?? '';
    });
  }

  void _saveAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveLoginData', _saveLoginData);
    prefs.setString('accountName', _accountName);
  }

  void _logout() async {
    try {
      // Cierra sesión en Firebase
      await FirebaseAuth.instance.signOut();

      // Limpia los datos almacenados localmente
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Redirige al usuario a la pantalla de inicio de sesión
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 2,
        title: const Text(
          'Configuración',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: <Widget>[
            Card(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Color.fromARGB(255, 0, 0, 0)),
                title: Text('Cuenta',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () {},
              ),
            ),
            Card(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SwitchListTile(
                title: Text('Guardar datos de inicio de sesión',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.brown.shade900)),
                value: _saveLoginData,
                onChanged: (bool value) {
                  setState(() {
                    _saveLoginData = value;
                  });
                  _saveAccountData();
                },
                secondary: const Icon(Icons.save, color: Colors.brown),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Cerrar sesión',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.redAccent)),
                onTap: () {
                  _logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
