import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    const Text('Pantalla de Casa'),
    const Text('Pantalla de Perfil'),
    const Text('Pantalla de Configuració'),
    UserPostsScreen(), // Pantalla de Publicacions
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Casa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuració',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Publicació',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class UserPostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Pantalla de tablet
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: 20, // Número de publicaciones
            itemBuilder: (context, index) {
              return Card(
                child: Center(child: Text('Publicació $index')),
              );
            },
          );
        } else {
          // Pantalla de móvil
          return ListView.builder(
            itemCount: 20, // Número de publicaciones
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Publicació $index'),
              );
            },
          );
        }
      },
    );
  }
}
