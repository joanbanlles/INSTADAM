import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
            tooltip: 'Salir',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoriesSection(),
            Divider(),
            PostSection(),
          ],
        ),
      ),
    );
  }

 
  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
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
        itemCount: userNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/image$index.png'),
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
        PostItem(
          username: 'gerard_farre',
          location: 'casa elodia',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['¡Qué bonito!', '¡Me encanta!'],
        ),
        PostItem(
          username: 'Orlando_212',
          location: 'CKNO',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['Aspolandole'],
        ),
        PostItem(
          username: 'Alejandro_123',
          location: 'newyork',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['me voy a ver aviones'],
        ),
        PostItem(
          username: 'juanillo05',
          location: 'florida135',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['canya canya'],
        ),
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(userImage),
          ),
          title: Text(username),
          subtitle: Text(location),
          trailing: Icon(Icons.more_vert),
        ),

        Center(
          child: Image.asset(postImage),
        ),
  
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Añadir un comentario...',
            ),
            onSubmitted: (value) {
      
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}
