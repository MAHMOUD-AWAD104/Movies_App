import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

abstract class MovieDetailsRepo {
  Future<Either<Failure, MovieEntity>> getMovieDetails({required int movieId});
  Future<Either<Failure, List<MovieEntity>>> getMovieSuggestions(
      {required int movieId});
}
