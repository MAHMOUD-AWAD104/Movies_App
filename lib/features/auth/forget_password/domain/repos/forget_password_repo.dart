import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';

abstract class ForgetPasswordRepo {
  Future<Either<Failure, String>> forgetPassword({required String email});
}
