import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instadam/screens/ChatScreen.dart';

import 'chat_screen.dart'; // Asegúrate de importar tu pantalla de chat

class UserListScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode
        ? '$uid1\_$uid2'
        : '$uid2\_$uid1';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Selecciona un usuari')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs.where((doc) => doc.id != currentUser!.uid).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['email']),
                onTap: () {
                  final chatId = getChatId(currentUser!.uid, user.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chatId,
                        otherUserId: user.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
