import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  void addComment(String content) {
    FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'comment': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
  }

  void deleteComment(String commentId) {
    FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFE0B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .doc(widget.postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comments = snapshot.data!.docs;
                  if (comments.isEmpty) {
                    return const Center(
                      child: Text(
                        'No comments yet. Be the first!',
                        style: TextStyle(color: Colors.brown, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final commentData =
                          comments[index].data() as Map<String, dynamic>;
                      final commentContent = commentData['comment'] ?? '';
                      final commentId = comments[index].id;

                      return Card(
                        color: const Color(0xFFFFF3E0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(
                            commentContent,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.brown,
                            ),
                          ),
                          leading:
                              const Icon(Icons.comment, color: Colors.brown),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Comment'),
                                  content: const Text(
                                      'Are you sure you want to delete this comment?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteComment(commentId);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.brown),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle:
                            TextStyle(color: Colors.brown.withOpacity(0.7)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      color: Colors.brown,
                      child: InkWell(
                        onTap: () {
                          final content = _commentController.text.trim();
                          if (content.isNotEmpty) {
                            addComment(content);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.send, color: Colors.white),
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
