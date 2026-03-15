import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/tabs/home/domain/repos/movies_repo.dart';

class GetMoviesUseCase {
  final MoviesRepo repo;
  GetMoviesUseCase(this.repo);

  Future<Either<Failure, List<MovieEntity>>> call(GetMoviesParams params) {
    return repo.getMovies(
      page: params.page,
      limit: params.limit,
      quality: params.quality,
      genre: params.genre,
      sortBy: params.sortBy,
      orderBy: params.orderBy,
      minimumRating: params.minimumRating,
    );
  }
}

class GetMoviesParams {
  final int page;
  final int limit;
  final String? quality;
  final String? genre;
  final String? sortBy;
  final String? orderBy;
  final int? minimumRating;

  const GetMoviesParams({
    this.page = 1,
    this.limit = 20,
    this.quality,
    this.genre,
    this.sortBy,
    this.orderBy,
    this.minimumRating,
  });
}
