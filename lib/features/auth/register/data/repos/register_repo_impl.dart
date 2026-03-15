import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/api_constants.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/auth/login/data/repos/login_repo_impl.dart';
import 'package:movies_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:movies_app/features/auth/register/domain/repos/register_repo.dart';

class RegisterRepoImpl implements RegisterRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  RegisterRepoImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password2': password,
        },
      );
      return Right(UserModel.fromJson(response.data['data']));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
