import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static Future<void> addMovieToHistory(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('history')
          .doc(movie.id.toString())
          .set({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'watchedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> updateUserData(
      String name, String phone, String avatar) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'name': name,
        'phone': phone,
        'avatar': avatar,
      }, SetOptions(merge: true));
    }
  }
}
