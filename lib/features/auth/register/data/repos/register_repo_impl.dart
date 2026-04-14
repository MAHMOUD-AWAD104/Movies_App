import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/register/domain/repos/register_repo.dart';
import 'package:movies_app/features/auth/data/models/user_model.dart';

class RegisterRepoImpl implements RegisterRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  RegisterRepoImpl({
    required this.apiClient,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required String email,
    required String password,
    required String phone,
    String? avatarPath,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final credential = await fb.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;

      if (user == null) {
        return const Left(ServerFailure(message: 'فشل إنشاء المستخدم'));
      }

      await user.updateDisplayName(username.trim());

      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'uId': user.uid,
        'username': username.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'avatar': avatarPath ?? 'assets/images/avatar1.png',
        'history': <Map<String, dynamic>>[],
        'watchlist': <Map<String, dynamic>>[],
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(
        UserModel(
          uid: user.uid,
          id: user.uid.hashCode,
          username: username.trim(),
          email: email.trim(),
          phone: phone.trim(),
          avatar: avatarPath ?? 'assets/images/avatar1.png',
          history: [],
          watchlist: [],
        ),
      );
    } on fb.FirebaseAuthException catch (e) {
      String errorMsg = 'حدث خطأ أثناء التسجيل';

      if (e.code == 'email-already-in-use') {
        errorMsg = 'هذا البريد الإلكتروني مسجل بالفعل';
      } else if (e.code == 'weak-password') {
        errorMsg = 'كلمة المرور ضعيفة جداً';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'البريد الإلكتروني غير صحيح';
      }

      return Left(ServerFailure(message: errorMsg));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}