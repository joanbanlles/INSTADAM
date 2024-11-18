import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instadam'),
      ),
      body: const InstadamBody(),
    );
  }
}

class InstadamBody extends StatelessWidget {
  const InstadamBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StoriesSection(),
          const Divider(),
          const PostSection(),
        ],
      ),
    );
  }
}

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  final List<String> userNames = const [
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
                const SizedBox(height: 5),
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
  const PostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        // Publicación 1
        PostItem(
          username: 'gerard_farre',
          location: 'casa elodia',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['Nice post!', 'Awesome!'],
        ),
        // Publicación 2
        PostItem(
          username: 'orlando_212',
          location: 'Madrid',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
          comments: ['Great!', 'Love it!'],
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
  const PostItem({
    super.key,
    required this.username,
    required this.location,
    required this.userImage,
    required this.postImage,
    required this.comments,
  });

  final String username;
  final String location;
  final String userImage;
  final String postImage;
  final List<String> comments;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(userImage),
            ),
            title: Text(username),
            subtitle: Text(location),
          ),
          Image.asset(postImage),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: comments.map((comment) => Text(comment)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
