import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de imágenes para las publicaciones
    final List<String> postImages = [
      'assets/images5.jpg',
      'assets/image2.png',
      'assets/images7.jpg',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'gfarree',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Información del perfil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.pink,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: AssetImage('assets/image10.png'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Estadísticas del perfil
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('3', 'Posts'),
                            _buildStatColumn('5', 'Followers'),
                            _buildStatColumn('3', 'Following'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Nombre y Bio del perfil
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Gerard Farré',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Lleida | Ilerna',
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Botones de perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('Following'),
                  _buildButton('Message'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Historias destacadas
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 16),
                  _buildHighlight('Casa', 'assets/images5.jpg'),
                  const SizedBox(width: 16),
                  _buildHighlight('Menja', 'assets/image2.png'),
                  const SizedBox(width: 16),
                  _buildHighlight('Viatjes', 'assets/images7.jpg'),
                  const SizedBox(width: 16),
                  _buildHighlight('Estil de vida', 'assets/images8.jpg'),
                  const SizedBox(width: 16),
                  _buildHighlight('Natura', 'assets/images9.jpg'),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            // Cuadrícula de publicaciones
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: postImages.length, // Número de publicaciones
              itemBuilder: (context, index) {
                return Container(
                  color: const Color.fromARGB(255, 106, 106, 106),
                  child: Image.asset(
                    postImages[index], // Cargar la imagen correspondiente de la lista
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper para columna de estadísticas
  Column _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
        ),
      ],
    );
  }

  // Helper para botones
  ElevatedButton _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }

  // Helper para destacados de historias
  Column _buildHighlight(String title, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
          backgroundColor: const Color.fromRGBO(158, 158, 158, 1),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
