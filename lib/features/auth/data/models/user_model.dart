import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel extends UserEntity {
  final String uid;
  final String phone;
  final String avatar;
  final List<dynamic> history;
  final List<dynamic> watchlist;

  const UserModel({
    required this.uid,
    required super.id,
    required super.username,
    required super.email,
    required this.phone,
    required this.avatar,
    required this.history,
    required this.watchlist,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final uid = json['uId'] ?? '';

    return UserModel(
      uid: uid,
      id: uid.hashCode,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? 'assets/images/avatar1.png',
      history: json['history'] ?? [],
      watchlist: json['watchlist'] ?? [],
    );
  }

  factory UserModel.fromFirebase({
    required fb.User user,
    required Map<String, dynamic> data,
  }) {
    return UserModel(
      uid: user.uid,
      id: user.uid.hashCode,
      username: data['username'] ?? user.displayName ?? '',
      email: user.email ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? 'assets/images/avatar1.png',
      history: data['history'] ?? [],
      watchlist: data['watchlist'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'history': history,
      'watchlist': watchlist,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}