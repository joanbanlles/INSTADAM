import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configuración',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
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
        title: Text(
          'Configuración',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Busca',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          Divider(),

          // Opción: Guardar datos de inicio de sesión
          ListTile(
            leading: Icon(Icons.save, color: Colors.black),
            title: Text('Guardar datos de inicio de sesión'),
            trailing: Switch(
              value: _saveLoginData,
              onChanged: (bool value) {
                setState(() {
                  _saveLoginData = value;
                  // Aquí podrías añadir la lógica para guardar el valor localmente en el futuro.
                });
              },
            ),
          ),
          Divider(),

          // Opciones de configuración
          ListTile(
            leading: Icon(Icons.person_add_alt, color: Colors.black),
            title: Text('Seguir e invitar a amigos'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.access_time, color: Colors.black),
            title: Text('Tu actividad'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined, color: Colors.black),
            title: Text('Notificaciones'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.black),
            title: Text('Privacidad'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.black),
            title: Text('Seguridad'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.campaign_outlined, color: Colors.black),
            title: Text('Anuncios'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.black),
            title: Text('Cuenta'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.black),
            title: Text('Ayuda'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.black),
            title: Text('Información'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
