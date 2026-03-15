import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

abstract class SearchRepo {
  Future<Either<Failure, List<MovieEntity>>> searchMovies({
    required String query,
    int page = 1,
  });
}
