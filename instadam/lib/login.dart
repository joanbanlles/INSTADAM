import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores para capturar los datos del usuario
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Simulación de base de datos de usuarios
    final List<Map<String, String>> users = [
      {'username': 'user1', 'password': 'password1'},
      {'username': 'user2', 'password': 'password2'},
    ];

    void login() {
      final username = usernameController.text;
      final password = passwordController.text;

      final Map<String, String>? user = users.firstWhere(
            (user) => user['username'] == username && user['password'] == password,
        orElse: () => <String, String>{}, // Return an empty map instead of null
      );

      if (user != null) {
        // Si el login es exitoso, navega a la página de Home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Muestra un mensaje de error si el usuario o la contraseña son incorrectos
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Usuario o contraseña incorrectos'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    void navigateToSignUp() {
      // Navega a la pantalla de registro
      Navigator.pushNamed(context, '/signup');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed: navigateToSignUp,
              child: Text('¿No tienes cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
