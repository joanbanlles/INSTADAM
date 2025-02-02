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
        title: const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
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
              child: comments.isEmpty
                  ? const Center(
                child: Text(
                  'No comments yet. Be the first!',
                  style: TextStyle(color: Colors.brown, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFFFFF3E0),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        comments[index]['content'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.brown),
                      ),
                      leading: const Icon(Icons.comment, color: Colors.brown),
                    ),
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
                        hintStyle: TextStyle(color: Colors.brown.withOpacity(0.7)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
