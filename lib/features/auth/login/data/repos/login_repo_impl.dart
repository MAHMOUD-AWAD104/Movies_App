import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/login/domain/repos/login_repo.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.apiKey,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      apiKey: json['api_key'] ?? '',
    );
  }
}

class LoginRepoImpl implements LoginRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  LoginRepoImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    // YTS doesn't have real auth - simulate login
    await Future.delayed(const Duration(seconds: 1));
    return Right(
      UserModel(
        id: 1,
        username: email.split('@').first,
        email: email,
        apiKey: 'demo_key',
      ),
    );
  }
}
