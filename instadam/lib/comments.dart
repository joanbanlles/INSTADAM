import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class CommentsScreen extends StatefulWidget {
  final int postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final data = await _databaseHelper.getComments(widget.postId);
    setState(() {
      comments = data;
    });
  }

  Future<void> addComment(String content) async {
    await _databaseHelper.insertComment(widget.postId, content);
    _commentController.clear();
    fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(comments[index]['content']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = _commentController.text.trim();
                    if (content.isNotEmpty) {
                      addComment(content);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
