import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import del paquete image_picker
import 'dart:io'; // Import necesario para trabajar con archivos (File)

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

  final List<File> capturedImages = []; // Lista para almacenar imágenes capturadas
  final ImagePicker _picker = ImagePicker(); // Instancia del selector de imágenes

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          capturedImages.add(File(photo.path));
        });
      }
    } catch (e) {
      print("Error al tomar la foto: $e");
    }
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
                image: DecorationImage(
                  image: AssetImage('assets/descarga.jpg'),
                  fit: BoxFit.cover,
                ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageDetailScreen(
                              imagePath: imagePaths[index],
                            ),
                          ),
                        );
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
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(capturedImages[capturedIndex]),
                          fit: BoxFit.cover,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

// Pantalla de detalle de imagen en pantalla completa
class ImageDetailScreen extends StatelessWidget {
  final String imagePath;

  ImageDetailScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueGrey[800]),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
