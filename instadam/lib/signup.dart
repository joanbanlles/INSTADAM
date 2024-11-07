import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Simulación de base de datos de usuarios
  final List<Map<String, String>> users = [];

  void _register() {
    final name = _nameController.text;
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Verificación de campos vacíos
    if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      _showErrorDialog('Por favor, completa todos los campos.');
      return;
    }

    // Verificación de duplicación de email o nombre de usuario
    final userExists = users.any((user) => user['email'] == email || user['username'] == username);
    if (userExists) {
      _showErrorDialog('El correo electrónico o el nombre de usuario ya están en uso.');
      return;
    }

    // Registro exitoso, se añade el usuario a la "base de datos"
    users.add({
      'name': name,
      'email': email,
      'username': username,
      'password': password,
    });

    // Navegar a la pantalla de Home
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre Completo'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
