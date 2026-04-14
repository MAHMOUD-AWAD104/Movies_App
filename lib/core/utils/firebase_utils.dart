import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static Future<void> addMovieToHistory(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .set({
        'history': FieldValue.arrayUnion([
          {
            'id': movie.id,
            'title': movie.title,
            'posterPath': movie.posterPath,
            'watchedAt': DateTime.now().toIso8601String(),
          }
        ]),
      }, SetOptions(merge: true));
    }
  }

  static Future<void> addMovieToWatchlist(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .set({
        'watchlist': FieldValue.arrayUnion([
          {
            'id': movie.id,
            'title': movie.title,
            'posterPath': movie.posterPath,
            'addedAt': DateTime.now().toIso8601String(),
          }
        ]),
      }, SetOptions(merge: true));
    }
  }

  static Future<void> updateUserData(
      String name,
      String phone,
      String avatar,
      ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'username': name,
        'phone': phone,
        'avatar': avatar,
      }, SetOptions(merge: true));
    }
  }
}