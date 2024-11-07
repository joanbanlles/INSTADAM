import 'package:flutter/material.dart';

void main() {
  runApp(Newpost());
}

class Newpost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evento Demo',
      theme: ThemeData.light(), // Tema claro para el diseño solicitado
      home: NewPostScreen(),
    );
  }
}

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nueva Publicación',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Siguiente',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0, // Quita la sombra para un diseño más plano
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Imagen debajo del AppBar
          Image.asset(
            'assets/descarga.jpg', // Ruta de tu imagen
            height: 250,
           // Altura ajustada para la imagen
            width: 250,
            fit: BoxFit.cover,
          ),
          
          // Imagen destacada
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200, // Altura de la imagen destacada
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/descargajpg'), // Reemplaza con la ruta de tu imagen destacada
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Reduce the space between the images
          SizedBox(height: 8),

          // Cuadrícula de imágenes
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: 9, // Número de elementos en la cuadrícula
              itemBuilder: (context, index) {
                return Container(
                  color: Color.fromARGB(255, 122, 122, 122), // Color de fondo de los elementos de la cuadrícula
                  child: Center(
                    child: Icon(
                      Icons.photo, // Icono representativo de una imagen
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
