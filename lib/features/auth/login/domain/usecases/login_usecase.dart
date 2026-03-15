import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/login/domain/repos/login_repo.dart';

class LoginUseCase {
  final LoginRepo repo;
  LoginUseCase(this.repo);

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repo.login(email: params.email, password: params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}
