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

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFE0B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: <Widget>[
            Card(
              color: Color(0xFFFFF3E0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.brown),
                title: Text('Cuenta', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.brown.shade900)),
                onTap: () {},
              ),
            ),
            Card(
              color: Color(0xFFFFF3E0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: SwitchListTile(
                title: Text('Guardar datos de inicio de sesión', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.brown.shade900)),
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
              color: Color(0xFFFFF3E0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent)),
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

