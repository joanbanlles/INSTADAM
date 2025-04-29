import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instadam/comments.dart'; // Asegúrate de tener la pantalla de comentarios
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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

class StoriesSection extends StatefulWidget {
  const StoriesSection({super.key});

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  final String STORIES_KEY = 'user_stories';
  final List<String> userNames = [
    'Tu historia',
    'juanillo05',
    'orlando_212',
    'gerard_farre',
    'alejandro_drope',
    'carlitos_123',
  ];

  final List<List<String>> userStories = [
    [], // Para tus historias
    [
      'assets/images/story1_juanillo.webp',
      'assets/images/story2_juanillo.jpg',
      'assets/images/story3_juanillo.avif'
    ],
    ['assets/images/story1_orlando.jpg', 'assets/images/story2_orlando.jpg'],
    ['assets/images/story1_gerard.jpg', 'assets/images/story2_gerard.avif'],
    [
      'assets/images/story1_alejandro.jpg',
      'assets/images/story2_alejandro.jpg'
    ],
    ['assets/images/story1_carlitos.jpg', 'assets/images/story2_carlitos.avif'],
  ];

  String? _currentUsername;
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadStoriesFromPrefs(); // Cargar historias guardadas
  }

  // Método para cargar historias guardadas
  Future<void> _loadStoriesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stories = prefs.getStringList(STORIES_KEY);
    if (stories != null) {
      setState(() {
        userStories[0] = stories;
      });
    }
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _currentUsername = userDoc.get('username') ?? 'Tu historia';
          _profileImage = userDoc.get('profileImage') ??
              'assets/images/default_profile.jpg';
          userNames[0] = _currentUsername!;
        });
      }
    }
  }

  Future<void> _addStory(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Copiar la imagen a un directorio permanente
      final permanentImage = await _saveImagePermanently(pickedFile.path);

      setState(() {
        if (userStories[0].isEmpty) {
          userStories[0] = [permanentImage];
        } else {
          userStories[0] = [...userStories[0], permanentImage];
        }
      });

      // Guardar las historias en SharedPreferences
      await _saveStoriesToPrefs(userStories[0]);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
              username: _currentUsername ?? 'Tu historia',
              storyImages: userStories[0],
              initialIndex: userStories[0].length - 1,
            ),
          ),
        );
      }
    }
  }

  Future<String> _saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = DateTime.now().microsecondsSinceEpoch.toString();
    final image = File(imagePath);
    final newImage = await image.copy('${directory.path}/$name.jpg');
    return newImage.path;
  }

  Future<void> _saveStoriesToPrefs(List<String> stories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(STORIES_KEY, stories);
    } catch (e) {
      print('Error guardando en SharedPreferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userNames.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                if (userStories[0].isEmpty) {
                  _addStory(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryDetailScreen(
                        username: _currentUsername ?? 'Tu historia',
                        storyImages: userStories[0],
                        initialIndex: 0,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: userStories[0].isEmpty
                                  ? Colors.blue
                                  : Colors.green,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: userStories[0].isNotEmpty
                                ? Image.file(
                                    File(userStories[0].last),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Error loading image: $error');
                                      return const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                          ),
                        ),
                        if (userStories[0].isNotEmpty)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => _addStory(context),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userStories[0].isEmpty
                          ? 'Tu historia'
                          : _currentUsername ?? 'Tu historia',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Resto de historias
          return GestureDetector(
            onTap: () {
              if (userStories[index].isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetailScreen(
                      username: userNames[index],
                      storyImages: userStories[index],
                      initialIndex: 0,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 3),
                      boxShadow: const [
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
                  Text(
                    userNames[index],
                    style: const TextStyle(
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
    bool liked =
        prefs.getBool('liked_${widget.username}_${currentIndex}') ?? false;
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
      [
        'assets/images/story1_juanillo.webp',
        'assets/images/story2_juanillo.jpg',
        'assets/images/story3_juanillo.avif'
      ],
      ['assets/images/story1_orlando.jpg', 'assets/images/story2_orlando.jpg'],
      ['assets/images/story1_gerard.jpg', 'assets/images/story2_gerard.avif'],
      [
        'assets/images/story1_alejandro.jpg',
        'assets/images/story2_alejandro.jpg'
      ],
      [
        'assets/images/story1_carlitos.jpg',
        'assets/images/story2_carlitos.avif'
      ],
    ];

    // Obtener el índice del siguiente usuario
    final nextIndex =
        (userNames.indexOf(widget.username) + 1) % userNames.length;

    // Si no hay más usuarios, vuelve a la pantalla principal
    if (nextIndex == 0) {
      Navigator.pop(
          context); // Cierra la pantalla de historia y regresa a la pantalla principal
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: _nextStory,
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _previousStory();
            } else if (details.primaryVelocity! < 0) {
              _nextStory();
            }
          },
          child: Stack(
            children: [
              // Main story image
              Center(
                child: widget.storyImages[currentIndex].startsWith('assets/')
                    ? Image.asset(
                        widget.storyImages[currentIndex],
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(widget.storyImages[currentIndex]),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                          );
                        },
                      ),
              ),
              // Top bar with username and progress indicators
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progress indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: List.generate(
                        widget.storyImages.length,
                        (index) => Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            color: currentIndex >= index
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom interaction bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        onPressed: _toggleLike,
                      ),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enviar mensaje...',
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay publicaciones'));
        }

        var posts = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index].data() as Map<String, dynamic>;
            return PostItem(
              postId: posts[index].id,
              username: post['username'] ?? 'Usuario anónimo',
              location: post['location'] ?? 'Sin ubicación',
              userImage: post['userImage'] ?? 'assets/images/user1.jpg',
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
              backgroundImage: widget.userImage.startsWith('assets/')
                  ? AssetImage(widget.userImage)
                  : FileImage(File(widget.userImage)) as ImageProvider,
            ),
            title: Text(widget.username),
            subtitle: Text(widget.location),
          ),
          Image.file(
            File(widget.postImage),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return Container(
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      likeCount += isLiked ? 1 : -1;
                    });
                  },
                ),
                Text('$likeCount likes'),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentsScreen(postId: widget.postId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.comment),
                  label: const Text('Comments'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
