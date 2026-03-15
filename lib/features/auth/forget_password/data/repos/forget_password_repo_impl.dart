import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/api_constants.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/auth/forget_password/domain/repos/forget_password_repo.dart';

class ForgetPasswordRepoImpl implements ForgetPasswordRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  ForgetPasswordRepoImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, String>> forgetPassword(
      {required String email}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await apiClient.post(
        ApiConstants.forgetPassword,
        data: {'email': email},
      );
      return const Right('Password reset email sent!');
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
