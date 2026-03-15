import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/api_constants.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/home/tabs/home/data/models/movie_model.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/tabs/home/domain/repos/movies_repo.dart';

class MoviesRepoImpl implements MoviesRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  MoviesRepoImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    int page = 1,
    int limit = 20,
    String? quality,
    String? genre,
    String? sortBy,
    String? orderBy,
    int? minimumRating,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await apiClient.get(
        ApiConstants.listMovies,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (quality != null) 'quality': quality,
          if (genre != null) 'genre': genre,
          if (sortBy != null) 'sort_by': sortBy,
          if (orderBy != null) 'order_by': orderBy,
          if (minimumRating != null) 'minimum_rating': minimumRating,
        },
      );

      final movies = (response.data['data']['movies'] as List<dynamic>)
          .map((m) => MovieModel.fromJson(m))
          .toList();

      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
