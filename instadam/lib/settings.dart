import 'package:flutter/material.dart';

void main() => runApp(Settings());

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _saveLoginData = false;

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
            leading: const Icon(Icons.person_add_alt, color: Colors.black),
            title: const Text('Seguir e invitar a amigos'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.access_time, color: Colors.black),
            title: const Text('Tu actividad'),
            onTap: () {},
          ),
          ListTile(
            leading:
                const Icon(Icons.notifications_outlined, color: Colors.black),
            title: const Text('Notificaciones'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.black),
            title: const Text('Privacidad'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.black),
            title: const Text('Seguridad'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.campaign_outlined, color: Colors.black),
            title: const Text('Anuncios'),
            onTap: () {},
          ),
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
            },
            secondary: const Icon(Icons.save, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
