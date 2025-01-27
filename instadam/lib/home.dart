import 'package:flutter/material.dart';
import 'package:instadam/comments.dart';
import 'DatabaseHelper.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        PostItem(
          postId: 1,
          username: 'gerard_farre',
          location: 'casa elodia',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
        ),
        PostItem(
          postId: 2,
          username: 'orlando_212',
          location: 'Madrid',
          userImage: 'assets/images.png',
          postImage: 'assets/descarga.jpg',
        ),
      ],
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

  final int postId;
  final String username;
  final String location;
  final String userImage;
  final String postImage;

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  List<Map<String, dynamic>> comments = [];
  bool isLiked = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    fetchComments();
    loadLikeState();
  }

  Future<void> fetchComments() async {
    final data = await _databaseHelper.getComments(widget.postId);
    setState(() {
      comments = data;
    });
  }

  Future<void> addComment(String content) async {
    await _databaseHelper.insertComment(widget.postId, content);
    fetchComments();
  }

  Future<void> loadLikeState() async {
    final liked = await _databaseHelper.isPostLiked(widget.postId);
    setState(() {
      isLiked = liked;
    });
  }

  void toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });
    await _databaseHelper.insertLike(widget.postId, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(widget.userImage),
          ),
          title: Text(widget.username),
          subtitle: Text(widget.location),
          trailing: const Icon(Icons.more_vert),
        ),
        Center(
          child: Image.asset(widget.postImage),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.black,
              ),
              onPressed: toggleLike,
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(postId: widget.postId),
                  ),
                );
              },
              child: const Text('View Comments'),
            ),
          ],
        ),
      ],
    );
  }
}
