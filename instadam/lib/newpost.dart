import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instadam/home.dart';

class Newpost extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<Newpost> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

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

  void _createPost(BuildContext context) async {
    if (_selectedImage != null) {
      try {
        String imagePath = _selectedImage!.path;

        await FirebaseFirestore.instance.collection('posts').add({
          'username': 'gerard_farre',
          'location': 'El campo',
          'userImage': 'assets/images/user1.jpg',
          'postImage': imagePath,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context, imagePath);
      } catch (e) {
        print("Error al crear el post: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Publicación'),
        actions: [
          TextButton(
            onPressed: () => _createPost(context),
            child: const Text('Siguiente'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text('Seleccionar Imagen'),
            ),
          ],
        ),
      ),
    );
  }
}
