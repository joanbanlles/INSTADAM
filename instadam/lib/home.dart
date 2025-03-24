import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instadam/comments.dart'; // Asegúrate de tener la pantalla de comentarios
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instadam'),
        backgroundColor: Colors.white,
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
          PostSection(),
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

  final List<List<String>> userStories = const [
    ['assets/images/story1_juanillo.webp', 'assets/images/story2_juanillo.jpg', 'assets/images/story3_juanillo.avif'],
    ['assets/images/story1_orlando.jpg', 'assets/images/story2_orlando.jpg'],
    ['assets/images/story1_gerard.jpg', 'assets/images/story2_gerard.avif'],
    ['assets/images/story1_alejandro.jpg', 'assets/images/story2_alejandro.jpg'],
    ['assets/images/story1_carlitos.jpg', 'assets/images/story2_carlitos.avif'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navegar a la pantalla de historias
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryDetailScreen(
                    username: userNames[index],
                    storyImages: userStories[index],
                    initialIndex: 0, // Comienza con la primera imagen de la historia
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  // Imagen de perfil con borde y sombra
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(userStories[index][0]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Nombre de usuario con texto estilizado
                  Text(
                    userNames[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final String username;
  final List<String> storyImages;
  final int initialIndex;

  const StoryDetailScreen({
    super.key,
    required this.username,
    required this.storyImages,
    required this.initialIndex,
  });

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late int currentIndex;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // Comienza con la imagen inicial
    _loadLikeStatus();
  }

  void _loadLikeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool liked = prefs.getBool('liked_${widget.username}_${currentIndex}') ?? false;
    setState(() {
      isLiked = liked;
    });
  }

  void _toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = !isLiked;
    });
    prefs.setBool('liked_${widget.username}_${currentIndex}', isLiked);
  }

  void _nextStory() {
    if (currentIndex < widget.storyImages.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Si es la última foto de la historia, ir a la siguiente historia o cerrar la pantalla
      _goToNextUserStory();
    }
  }

  void _previousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _goToNextUserStory() {
    final userNames = [
      'juanillo05',
      'orlando_212',
      'gerard_farre',
      'alejandro_drope',
      'carlitos_123',
    ];

    final userStories = [
      ['assets/images/story1_juanillo.webp', 'assets/images/story2_juanillo.jpg', 'assets/images/story3_juanillo.avif'],
      ['assets/images/story1_orlando.jpg', 'assets/images/story2_orlando.jpg'],
      ['assets/images/story1_gerard.jpg', 'assets/images/story2_gerard.avif'],
      ['assets/images/story1_alejandro.jpg', 'assets/images/story2_alejandro.jpg'],
      ['assets/images/story1_carlitos.jpg', 'assets/images/story2_carlitos.avif'],
    ];

    // Obtener el índice del siguiente usuario
    final nextIndex = (userNames.indexOf(widget.username) + 1) % userNames.length;

    // Si no hay más usuarios, vuelve a la pantalla principal
    if (nextIndex == 0) {
      Navigator.pop(context); // Cierra la pantalla de historia y regresa a la pantalla principal
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StoryDetailScreen(
            username: userNames[nextIndex],
            storyImages: userStories[nextIndex],
            initialIndex: 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s Story'),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: _nextStory, // Cambia la historia al hacer tap en el centro
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _previousStory(); // Desliza hacia la izquierda para retroceder
          } else if (details.primaryVelocity! < 0) {
            _nextStory(); // Desliza hacia la derecha para avanzar
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // El nombre del usuario en la parte superior
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.username,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45),
              ),
            ),
            // Barra de progreso para indicar la cantidad de imágenes en la historia
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.storyImages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
            // Imagen de la historia con un marco y sombra
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 35,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.storyImages[currentIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Corazón para dar like y campo de texto para escribir algo
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                      size: 32,
                    ),
                    onPressed: _toggleLike,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Escribe algo...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay publicaciones.'));
        }

        var posts = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index];
            return PostItem(
              postId: post.id,
              username: post['username'],
              location: post['location'],
              userImage: post['userImage'],
              postImage: post['postImage'],
            );
          },
        );
      },
    );
  }
}

class PostItem extends StatefulWidget {
  const PostItem({
    super.key,
    required this.postId,
    required this.username,
    required this.location,
    required this.userImage,
    required this.postImage,
  });

  final String postId;
  final String username;
  final String location;
  final String userImage;
  final String postImage;

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLiked = false;
  int likeCount = 0;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _getLikeStatus();
  }

  Future<void> _getLikeStatus() async {
    final postRef = FirebaseFirestore.instance.collection('likes').doc(widget.postId);
    final doc = await postRef.get();

    if (doc.exists) {
      setState(() {
        isLiked = doc['likedBy'].contains(FirebaseAuth.instance.currentUser!.uid);
        likeCount = doc['likeCount'] ?? 0;
      });
    }
  }

  Future<void> _toggleLike() async {
    final postRef = FirebaseFirestore.instance.collection('likes').doc(widget.postId);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final doc = await postRef.get();

    if (doc.exists) {
      if (isLiked) {
        await postRef.update({
          'likedBy': FieldValue.arrayRemove([userId]),
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        await postRef.update({
          'likedBy': FieldValue.arrayUnion([userId]),
          'likeCount': FieldValue.increment(1),
        });
      }
    } else {
      await postRef.set({
        'likedBy': [userId],
        'likeCount': 1,
      });
    }

    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Método para eliminar el post
  Future<void> _deletePost() async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    final likeRef = FirebaseFirestore.instance.collection('likes').doc(widget.postId);

    try {
      // Eliminar el post de la colección de posts
      await postRef.delete();

      // Eliminar los likes asociados al post
      await likeRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post eliminado con éxito.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el post.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.userImage),
            ),
            title: Text(widget.username),
            subtitle: Text(widget.location),
            trailing: PopupMenuButton<String>(onSelected: (value) {
              if (value == 'delete') {
                _deletePost(); // Eliminar el post
              }
            }, itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Eliminar Post'),
                ),
              ];
            }),
          ),
          GestureDetector(
            onTap: pickImage,
            child: _selectedImage == null
                ? Image.asset(widget.postImage, fit: BoxFit.cover)
                : Image.file(_selectedImage!, fit: BoxFit.cover),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                ),
                onPressed: _toggleLike,
              ),
              Text('$likeCount Likes'),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentsScreen(postId: widget.postId)),
                  );
                },
                child: const Text('View Comments'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
