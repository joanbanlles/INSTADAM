import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  // Base de datos de usuarios como lista estática
  static List<Map<String, String>> users = [];

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    final name = _nameController.text;
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      _showErrorDialog('Por favor, completa todos los campos.');
      return;
    }

    final userExists = SignUp.users.any((user) => user['email'] == email || user['username'] == username);
    if (userExists) {
      _showErrorDialog('El correo electrónico o el nombre de usuario ya están en uso.');
      return;
    }

    // Agregar usuario a la lista estática
    SignUp.users.add({
      'name': name,
      'email': email,
      'username': username,
      'password': password,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registro Exitoso'),
        content: Text('¡Tu cuenta ha sido creada exitosamente!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
