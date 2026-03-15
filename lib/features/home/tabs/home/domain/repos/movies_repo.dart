import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

abstract class MoviesRepo {
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    int page = 1,
    int limit = 20,
    String? quality,
    String? genre,
    String? sortBy,
    String? orderBy,
    int? minimumRating,
  });
}
