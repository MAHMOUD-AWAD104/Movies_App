import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/auth/data/models/user_model.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/login/domain/repos/login_repo.dart';

class LoginRepoImpl implements LoginRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  LoginRepoImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final credential = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        return const Left(ServerFailure(message: 'Login failed'));
      }

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      final data = doc.data() ?? {};

      return Right(
        UserModel.fromFirebase(
          user: user,
          data: data,
        ),
      );
    } on fb.FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Login failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}