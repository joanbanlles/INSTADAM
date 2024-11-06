import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instadam',
      theme: ThemeData(),
      home: Instadam(),
    );
  }
}

class Instadam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Instadam',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong', // Fuente similar a la de Instagram
            fontSize: 32,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: InstadamBody(),
      bottomNavigationBar: InstagramBottomNavBar(),
    );
  }
}

// Definir la barra de navegación inferior correctamente como widget
class InstagramBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage(
                'assets/profile_placeholder.jpg'), // Añade una imagen de perfil
          ),
          label: '',
        ),
      ],
    );
  }
}

class InstadamBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StoriesSection(),
          Divider(),
          PostSection(),
        ],
      ),
    );
  }
}

class StoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Número de historias
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      'assets/story_placeholder.jpg'), // Imagen de ejemplo
                ),
                SizedBox(height: 5),
                Text(
                  'Usuario $index',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PostSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado del usuario
        ListTile(
          leading: CircleAvatar(
            backgroundImage:
                AssetImage('assets/images.png'), // Imagen de usuario
          ),
          title: Text('gerard_farre'),
          subtitle: Text('Ubicación'),
          trailing: Icon(Icons.more_vert),
        ),
        // Imagen de la publicación
        Image.asset('assets/descarga.jpg'), // Imagen de ejemplo
        // Iconos de interacciones
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // Texto de likes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Liked by dark_emeralds and others',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // Descripción
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(
            'Este es un ejemplo de descripción para la publicación.',
          ),
        ),
      ],
    );
  }
}
