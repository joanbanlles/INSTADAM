import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart'; // Importa el paquete de SharedPreferences

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _userImage = '';
  String _userName = 'Usuario';
  int posts = 0, followers = 0, following = 0;
  Timer? _followersTimer;
  Timer? _followingTimer;

  // Lista de URLs de imágenes (puedes poner las que quieras)
  List<String> _posts = [
    'https://picsum.photos/200/300',
    'https://picsum.photos/201/300',
    'https://picsum.photos/202/300',
    'https://picsum.photos/203/300',
    'https://picsum.photos/204/300',
    'https://picsum.photos/205/300',
    'https://picsum.photos/206/300',
    'https://picsum.photos/207/300',
    'https://picsum.photos/208/300',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startFollowersTimer();
    _startFollowingTimer();
    _updatePostsCount(); // Actualizar posts al cargar
  }

  void _updatePostsCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        posts = _posts.length;
      });
      await _firestore.collection('usuarios').doc(user.uid).update({
        'posts': posts,
      });
      _saveToSharedPreferences(); // Guardar en SharedPreferences
    }
  }

  // Guardar en SharedPreferences
  Future<void> _saveToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('posts', posts);
    prefs.setString('userName', _userName);
    prefs.setString('userImage', _userImage);
    prefs.setStringList('posts', _posts); // Guardar la lista de posts
  }

  // Cargar desde SharedPreferences
  Future<void> _loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      posts = prefs.getInt('posts') ?? 0;
      _userName = prefs.getString('userName') ?? 'Usuario';
      _userImage = prefs.getString('userImage') ?? '';
      _posts = prefs.getStringList('posts') ?? [];
    });
  }

  @override
  void dispose() {
    // Detener los temporizadores cuando el widget se destruya
    _followersTimer?.cancel();
    _followingTimer?.cancel();
    super.dispose();
  }

  // Cargar los datos del usuario de Firestore
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('usuarios').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _userImage = userDoc['imageUrl'] ?? '';
          _userName = userDoc['nombre'] ?? 'Usuario';
          posts = userDoc['posts'] ?? 0;
          followers = userDoc['followers'] ?? 0;
          following = userDoc['following'] ?? 0;
        });

        // Si hay una imagen guardada, cargarla desde el almacenamiento local
        if (_userImage.isNotEmpty) {
          _loadImageFromLocal(_userImage);
        }
      } else {
        await _firestore.collection('usuarios').doc(user.uid).set({
          'nombre': _userName,
          'imageUrl': '',
          'posts': 0,
          'followers': 0,
          'following': 0,
        });
      }
    }
  }

  // Cargar la imagen almacenada en la memoria del dispositivo
  Future<void> _loadImageFromLocal(String imagePath) async {
    File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      setState(() {
        _image = imageFile;
      });
    }
  }

  // Seleccionar imagen y guardarla localmente
  Future<void> _changeProfileImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File newImage = File(pickedFile.path);
      User? user = _auth.currentUser;

      if (user != null) {
        // Guardar la imagen localmente
        String localPath = await _saveImageLocally(newImage);

        setState(() {
          _image = newImage;
          _userImage = localPath;
        });

        // Guardar la ruta en Firestore
        await _firestore.collection('usuarios').doc(user.uid).update({
          'imageUrl': localPath,
        });

        _saveToSharedPreferences(); // Guardar en SharedPreferences
      }
    }
  }

  // Guardar la imagen localmente
  Future<String> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final String newPath = '${directory.path}/profile.jpg';
    await imageFile.copy(newPath);
    return newPath;
  }

  // Método para eliminar la cuenta
  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Eliminar los datos del usuario de Firestore
      await _firestore.collection('usuarios').doc(user.uid).delete();

      // Eliminar la cuenta de Firebase Auth
      await user.delete();

      // Después de eliminar la cuenta, se puede redirigir al usuario a la pantalla de inicio de sesión o pantalla principal
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  // Iniciar temporizador para aumentar los seguidores
  void _startFollowersTimer() {
    _followersTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      setState(() {
        followers++;
      });
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('usuarios').doc(user.uid).update({
          'followers': followers,
        });
      }
    });
  }

  // Iniciar temporizador para aumentar los siguiendo
  void _startFollowingTimer() {
    _followingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      setState(() {
        following++;
      });
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('usuarios').doc(user.uid).update({
          'following': following,
        });
      }
    });
  }

  // Método para eliminar un post
  void _deletePost(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar publicación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta imagen?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _posts.removeAt(index); // Eliminar de la lista local
                });
                _updatePostsCount(); // Actualizar la cantidad de publicaciones
                _saveToSharedPreferences(); // Guardar en SharedPreferences
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('usuarios').doc(user?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Cargando...",
                  style: TextStyle(color: Colors.black));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text("Usuario",
                  style: TextStyle(color: Colors.black));
            }
            String userName = snapshot.data!['nombre'] ?? 'Usuario';
            return Text(userName, style: const TextStyle(color: Colors.black));
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _deleteAccount();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(
                    'Borrar Cuenta',
                    style: TextStyle(color: Colors.red), // Cambiar color a rojo
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _changeProfileImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : _userImage.isNotEmpty
                            ? FileImage(File(_userImage))
                            : null,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(posts.toString(), 'Posts'),
                      _buildStatColumn(followers.toString(), 'Followers'),
                      _buildStatColumn(following.toString(), 'Following'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Editar Perfil', _changeUserName),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () =>
                      _deletePost(index), // Borrar al mantener presionado
                  child: Image.network(
                    _posts[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  ElevatedButton _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Future<void> _changeUserName() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: _userName);
        return AlertDialog(
          title: const Text("Cambiar nombre de usuario"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nuevo nombre'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _userName = newName;
      });
      // Guardar el nombre de usuario en Firestore
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('usuarios').doc(user.uid).update({
          'nombre': newName,
        });
      }

      _saveToSharedPreferences(); // Guardar en SharedPreferences
    }
  }
}
