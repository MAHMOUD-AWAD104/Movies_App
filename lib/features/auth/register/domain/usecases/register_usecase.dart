import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/register/domain/repos/register_repo.dart';

class RegisterUseCase {
  final RegisterRepo repo;
  RegisterUseCase(this.repo);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repo.register(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String username;
  final String email;
  final String password;
  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  });
}
