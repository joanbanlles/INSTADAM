import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instadam'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () => _uploadStory(context),
          ),
        ],
      ),
      body: const InstadamBody(),
    );
  }

  static Future<void> _uploadStory(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser!;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('stories')
            .child(user.uid)
            .child(fileName);
        final uploadTask = await storageRef.putFile(file);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('stories').add({
          'userId': user.uid,
          'username': user.displayName ?? 'Usuario',
          'images': [downloadUrl],
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historia subida con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir historia: $e')),
        );
      }
    }
  }
}

class InstadamBody extends StatelessWidget {
  const InstadamBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('stories')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final stories = snapshot.data!.docs;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              final username = story['username'];
              final imageUrl = story['images'][0];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 30,
                    ),
                    SizedBox(height: 5),
                    Text(username, style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          );
        },
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
        if (!snapshot.hasData) return CircularProgressIndicator();
        final posts = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostItem(
              postId: post.id,
              username: post['username'],
              userImage: post['userImage'],
              postImage: post['postImage'],
              description: post['description'],
              location: post['location'],
            );
          },
        );
      },
    );
  }
}

class PostItem extends StatefulWidget {
  final String postId;
  final String username;
  final String userImage;
  final String postImage;
  final String description;
  final String location;

  const PostItem({
    required this.postId,
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.description,
    required this.location,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _getLikeStatus();
  }

  Future<void> _getLikeStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('likes')
        .doc(widget.postId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        isLiked = data['likedBy']?.contains(FirebaseAuth.instance.currentUser!.uid) ?? false;
        likeCount = data['likeCount'] ?? 0;
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.userImage),
            ),
            title: Text(widget.username),
            subtitle: Text(widget.location),
          ),
          Image.network(widget.postImage, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.description),
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
            ],
          ),
        ],
      ),
    );
  }
}
