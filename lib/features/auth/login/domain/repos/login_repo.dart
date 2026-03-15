import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';

abstract class LoginRepo {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
}
