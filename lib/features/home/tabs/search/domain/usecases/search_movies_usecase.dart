import 'package:dartz/dartz.dart';
import 'package:movies_app/core/error/failures.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/tabs/search/domain/repos/search_repo.dart';

class SearchMoviesUseCase {
  final SearchRepo repo;
  SearchMoviesUseCase(this.repo);

  Future<Either<Failure, List<MovieEntity>>> call(SearchMoviesParams params) {
    return repo.searchMovies(query: params.query, page: params.page);
  }
}

class SearchMoviesParams {
  final String query;
  final int page;
  const SearchMoviesParams({required this.query, this.page = 1});
}
