import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/home/movie_details/domain/repos/movie_details_repo.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

class GetMovieDetailsUseCase {
  final MovieDetailsRepo repo;
  GetMovieDetailsUseCase(this.repo);

  Future<Either<Failure, MovieEntity>> call(int movieId) {
    return repo.getMovieDetails(movieId: movieId);
  }
}

class GetMovieSuggestionsUseCase {
  final MovieDetailsRepo repo;
  GetMovieSuggestionsUseCase(this.repo);

  Future<Either<Failure, List<MovieEntity>>> call(int movieId) {
    return repo.getMovieSuggestions(movieId: movieId);
  }
}
