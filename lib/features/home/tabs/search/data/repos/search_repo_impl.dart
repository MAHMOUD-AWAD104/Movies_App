import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/api_constants.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/home/tabs/home/data/models/movie_model.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/tabs/search/domain/repos/search_repo.dart';

class SearchRepoImpl implements SearchRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  SearchRepoImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await apiClient.get(
        ApiConstants.listMovies,
        queryParameters: {
          'query_term': query,
          'page': page,
          'limit': 20,
        },
      );

      final movies = (response.data['data']['movies'] as List<dynamic>? ?? [])
          .map((m) => MovieModel.fromJson(m))
          .toList();

      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
