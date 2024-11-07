import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Instadam'),
        ),
        body: InstadamBody(),
        bottomNavigationBar: InstagramBottomNavBar(),
      ),
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
  final List<String> userNames = [
    'juanillo05',
    'orlando_212',
    'gerard_farre',
    'alejandro_drope',
    'carlitos_123',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userNames.length, // Número de historias
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(
                      'assets/story_image_$index.jpg'), // Asegúrate de que las imágenes existan
                ),
                SizedBox(height: 5),
                Text(userNames[index]),
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
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        // Publicación 1
        PostItem(
          username: 'gerard_farre',
          location: 'casa elodia',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['¡Qué bonito!', '¡Me encanta!'],
          postHeight: 400, // Adjust the height as needed
        ),
        // Publicación 2
        PostItem(
          username: 'Orlando_212',
          location: 'CKNO',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['Aspolandole'],
          postHeight: 400,
        ),
        PostItem(
          username: 'Alejandro_123',
          location: 'newyork',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['me voy a ver aviones'],
          postHeight: 400,
        ),
        PostItem(
          username: 'juanillo05',
          location: 'florida135',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['canya canya'],
          postHeight: 400,
        ),
        // Agrega más publicaciones aquí
      ],
    );
  }
}

class PostItem extends StatelessWidget {
  final String username;
  final String location;
  final String userImage;
  final String postImage;
  final List<String> comments;

  PostItem({
    required this.username,
    required this.location,
    required this.userImage,
    required this.postImage,
    required this.comments,
    required int postHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado del usuario
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(userImage), // Imagen de usuario
          ),
          title: Text(username),
          subtitle: Text(location),
          trailing: Icon(Icons.more_vert),
        ),
        // Imagen de la publicación
        Center(
          child: Image.asset(postImage),
        ),
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
              // Otros widgets aquí...
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comments.map((comment) => Text(comment)).toList(),
          ),
        ),
        // Campo de texto para agregar un nuevo comentario
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
            ),
            onSubmitted: (value) {
              // Manejar el envío del comentario aquí
            },
          ),
        ),
      ],
    );
  }
}

class InstagramBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      currentIndex: 0, // Índice del elemento seleccionado
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        // Manejar la navegación aquí
      },
    );
  }
}
