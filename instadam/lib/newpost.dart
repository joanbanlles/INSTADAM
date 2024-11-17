import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Newpost());
}

class Newpost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evento Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home: NewPostScreen(),
    );
  }
}

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final List<String> imagePaths = [
    'assets/images11.jpg',
    'assets/images12.jpg',
    'assets/images13.jpg',
    'assets/images14.jpg',
    'assets/foto15.webp',
    'assets/images16.webp',
    'assets/images17.jpg',
    'assets/images18.jpg',
    'assets/images19.jpg',
  ];

  List<File> capturedImages = [];
  final ImagePicker _picker = ImagePicker();
  String? selectedImage; 

  @override
  void initState() {
    super.initState();
    _loadCapturedImages();
    selectedImage = 'assets/descarga.jpg'; 
  }

  Future<void> _saveCapturedImages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> paths = capturedImages.map((file) => file.path).toList();
    await prefs.setStringList('capturedImages', paths);
  }

  Future<void> _loadCapturedImages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? paths = prefs.getStringList('capturedImages');
    if (paths != null) {
      setState(() {
        capturedImages = paths.map((path) => File(path)).toList();
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          capturedImages.add(File(photo.path));
          selectedImage = photo.path; 
        });
        await _saveCapturedImages();
      }
    } catch (e) {
      print("Error al tomar la foto: $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        setState(() {
          capturedImages.add(File(photo.path));
          selectedImage = photo.path; 
        });
        await _saveCapturedImages();
      }
    } catch (e) {
      print("Error al seleccionar la foto: $e");
    }
  }

  void _deleteSelectedImage() {
    if (selectedImage == null) return;
    setState(() {
     
      capturedImages.removeWhere((file) => file.path == selectedImage);
      selectedImage = null;
    });
    _saveCapturedImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nueva Publicación',
          style: TextStyle(
            color: Colors.blueGrey[800],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Siguiente',
              style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.w600),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.blueGrey[800]),
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                image: selectedImage != null
                    ? DecorationImage(
                  image: selectedImage!.startsWith('assets/')
                      ? AssetImage(selectedImage!) as ImageProvider
                      : FileImage(File(selectedImage!)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Galería de Imágenes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[800],
                ),
              ),
            ),
            SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(4.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                ),
                itemCount: imagePaths.length + capturedImages.length,
                itemBuilder: (context, index) {
                  if (index < imagePaths.length) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = imagePaths[index]; 
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  } else {
                    final capturedIndex = index - imagePaths.length;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = capturedImages[capturedIndex].path; 
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(capturedImages[capturedIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _pickImageFromGallery,
            child: Icon(Icons.image),
            backgroundColor: Colors.blueGrey,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _takePhoto,
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.blueGrey,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _deleteSelectedImage,
            child: Icon(Icons.delete),
            backgroundColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
