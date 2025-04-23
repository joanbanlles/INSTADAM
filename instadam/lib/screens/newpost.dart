import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instadam/screens/home.dart';

class Newpost extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<Newpost> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
      }
    } catch (e) {
      print("Error al seleccionar la foto: $e");
    }
  }

  Future<void> _createPost(BuildContext context) async {
    if (_selectedImage == null || _descController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser!;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      // Subir imagen a Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child(user.uid)
          .child(fileName);
      await ref.putFile(_selectedImage!);
      final imageUrl = await ref.getDownloadURL();

      // Guardar datos en Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'username': user.displayName ?? 'Usuario',
        'userImage': user.photoURL ?? '',
        'postImage': imageUrl,
        'description': _descController.text,
        'location': _locationController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      print("Error al subir el post: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir el post: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Publicación'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => _createPost(context),
            child: const Text('Subir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Center(child: Text("Toca para seleccionar imagen"))
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Ubicación",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Subir publicación"),
                  onPressed: _isLoading ? null : () => _createPost(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
