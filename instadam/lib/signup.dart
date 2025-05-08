import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> _register() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      _showErrorDialog('Por favor, completa todos los campos.');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      await user?.updateDisplayName(name);

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
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'Error desconocido');
    }
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
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/logo.png', height: 100),
                const Text(
                  '¡Conecta, crea y deja huella!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Crea una cuenta para comenzar',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                _buildRoundedTextField(_nameController, 'Nombre Completo'),
                const SizedBox(height: 10),
                _buildRoundedTextField(_emailController, 'Correo Electrónico'),
                const SizedBox(height: 10),
                _buildRoundedTextField(
                    _usernameController, 'Nombre de Usuario'),
                const SizedBox(height: 10),
                _buildRoundedTextField(_passwordController, 'Contraseña',
                    obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'OR',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedTextField(
      TextEditingController controller, String labelText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: obscureText,
    );
  }
}
