import 'package:dartz/dartz.dart';
import 'package:movies_app/core/constants/api_constants.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/home/movie_details/domain/repos/movie_details_repo.dart';
import 'package:movies_app/features/home/tabs/home/data/models/movie_model.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

class MovieDetailsRepoImpl implements MovieDetailsRepo {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  MovieDetailsRepoImpl({required this.apiClient, required this.networkInfo});

  @override
  Future<Either<Failure, MovieEntity>> getMovieDetails(
      {required int movieId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await apiClient.get(
        ApiConstants.movieDetails,
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
          'with_cast': true,
        },
      );

      final movie = MovieModel.fromJson(response.data['data']['movie']);
      return Right(movie);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovieSuggestions(
      {required int movieId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await apiClient.get(
        ApiConstants.movieSuggestions,
        queryParameters: {'movie_id': movieId},
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
