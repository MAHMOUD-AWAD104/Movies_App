import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/auth/forget_password/domain/repos/forget_password_repo.dart';

class ForgetPasswordUseCase {
  final ForgetPasswordRepo repo;
  ForgetPasswordUseCase(this.repo);

  Future<Either<Failure, String>> call(String email) {
    return repo.forgetPassword(email: email);
  }
}
