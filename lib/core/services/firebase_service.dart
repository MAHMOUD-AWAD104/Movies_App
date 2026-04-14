import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/features/auth/data/models/user_model.dart';

class FirebaseService {
  static CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection('Users')
        .withConverter<UserModel>(
      fromFirestore: (snapshot, _) {
        return UserModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) => user.toJson(),
    );
  }

  static Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String phone,
    String avatar = 'assets/images/avatar1.png',
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final firebaseUser = credential.user!;
    await firebaseUser.updateDisplayName(username.trim());

    final user = UserModel(
      uid: firebaseUser.uid,
      id: firebaseUser.uid.hashCode,
      username: username.trim(),
      email: email.trim(),
      phone: phone.trim(),
      avatar: avatar,
      history: [],
      watchlist: [],
    );

    await getUsersCollection().doc(firebaseUser.uid).set(user);

    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final doc =
    await getUsersCollection().doc(credential.user!.uid).get();

    return doc.data()!;
  }

  static Future<void> updateUserData({
    required String username,
    required String phone,
    required String avatar,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'uId': user.uid,
      'username': username.trim(),
      'phone': phone.trim(),
      'avatar': avatar,
    }, SetOptions(merge: true));
  }

  static Future<void> addMovieToHistory({
    required Map<String, dynamic> movie,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final data = doc.data() ?? {};
    List<dynamic> history = List.from(data['history'] ?? []);

    history.removeWhere((item) => item['id'] == movie['id']);

    history.insert(0, {
      ...movie,
      'watchedAt': DateTime.now().toIso8601String(),
    });

    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'history': history,
    }, SetOptions(merge: true));
  }

  static Future<void> addMovieToWatchlist({
    required Map<String, dynamic> movie,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'watchlist': FieldValue.arrayUnion([movie]),
    }, SetOptions(merge: true));
  }

  static Future<void> removeMovieFromWatchlist({
    required Map<String, dynamic> movie,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'watchlist': FieldValue.arrayRemove([movie]),
    }, SetOptions(merge: true));
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<UserModel?> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    final firebaseUser = userCredential.user;
    if (firebaseUser == null) return null;

    final usersCollection = getUsersCollection();
    final docSnapshot = await usersCollection.doc(firebaseUser.uid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return docSnapshot.data()!;
    }

    final user = UserModel(
      uid: firebaseUser.uid,
      id: firebaseUser.uid.hashCode,
      username: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      phone: '',
      avatar: 'assets/images/avatar1.png',
      history: [],
      watchlist: [],
    );

    await usersCollection.doc(firebaseUser.uid).set(user);

    return user;
  }

  static Future<bool> isMovieInWatchlist(int movieId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final data = doc.data() ?? {};
    final List<dynamic> watchlist = List.from(data['watchlist'] ?? []);

    return watchlist.any((item) => item['id'] == movieId);
  }

  static Future<void> toggleWatchlist({
    required Map<String, dynamic> movie,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final data = doc.data() ?? {};
    final List<dynamic> watchlist = List.from(data['watchlist'] ?? []);

    final exists = watchlist.any((item) => item['id'] == movie['id']);

    if (exists) {
      watchlist.removeWhere((item) => item['id'] == movie['id']);
    } else {
      watchlist.add({
        ...movie,
        'addedAt': DateTime.now().toIso8601String(),
      });
    }

    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'watchlist': watchlist,
    }, SetOptions(merge: true));
  }

  static Future<void> watchMovie({
    required Map<String, dynamic> movie,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
    FirebaseFirestore.instance.collection('Users').doc(user.uid);

    final doc = await docRef.get();
    final data = doc.data() ?? {};

    List<dynamic> history = List.from(data['history'] ?? []);
    List<dynamic> watchlist = List.from(data['watchlist'] ?? []);

    watchlist.removeWhere((item) => item['id'] == movie['id']);

    history.removeWhere((item) => item['id'] == movie['id']);

    history.insert(0, {
      ...movie,
      'watchedAt': DateTime.now().toIso8601String(),
    });

    await docRef.set({
      'history': history,
      'watchlist': watchlist,
    }, SetOptions(merge: true));
  }
}