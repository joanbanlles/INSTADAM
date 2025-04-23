import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveUserToFirestore(User user) async {
  final usersRef = FirebaseFirestore.instance.collection('usuarios');
  final doc = await usersRef.doc(user.uid).get();

  if (!doc.exists) {
    await usersRef.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'nombre': user.displayName ?? '',
      'imageUrl': '',
      'posts': 0,
      'followers': 0,
      'following': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
