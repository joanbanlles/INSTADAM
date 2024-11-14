// Importa los paquetes necesarios
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Implementación de la función _logout
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpiar todos los datos de SharedPreferences

    // Navegar a la pantalla de inicio o de inicio de sesión
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: <Widget>[
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.black),
            title: const Text('Cuenta'),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Guardar datos de inicio de sesión'),
            value: _saveLoginData,
            onChanged: (bool value) {
              setState(() {
                _saveLoginData = value;
              });
              _saveAccountData();
            },
            secondary: const Icon(Icons.save, color: Colors.black),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Cerrar sesión'),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }
}
