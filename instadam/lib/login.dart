import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DatabaseHelper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('savedUsername');
    final savedPassword = prefs.getString('savedPassword');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe && savedUsername != null && savedPassword != null) {
      setState(() {
        _usernameController.text = savedUsername;
        _passwordController.text = savedPassword;
        _rememberMe = rememberMe;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('savedUsername', _usernameController.text);
      await prefs.setString('savedPassword', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('savedUsername');
      await prefs.remove('savedPassword');
      await prefs.setBool('rememberMe', false);
    }
  }

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Por favor, ingresa usuario y contraseña');
      return;
    }

    try {
      final user = await _databaseHelper.getUser(username, password);

      if (user != null && user.isNotEmpty) {
        await _saveCredentials();
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog('Usuario o contraseña incorrectos');
      }
    } catch (e) {
      print("Error durante el inicio de sesión: $e");
      _showErrorDialog('Ocurrió un error al iniciar sesión');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                SizedBox(height: 20),
                Text(
                  '¡Conecta, crea y deja huella !',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Inicia sesión',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                _buildRoundedTextField(
                    _usernameController, 'Nombre de usuario'),
                SizedBox(height: 10),
                _buildRoundedTextField(_passwordController, 'Contraseña',
                    obscureText: true),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text('Recordar credenciales'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'OR',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Registrarse',
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
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
    );
  }
}
