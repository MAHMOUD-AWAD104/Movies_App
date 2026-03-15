import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/tabs/search/domain/usecases/search_movies_usecase.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchLoaded extends SearchState {
  final List<MovieEntity> movies;
  final String query;
  const SearchLoaded({required this.movies, required this.query});
  @override
  List<Object?> get props => [movies, query];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({required this.message});
  @override
  List<Object?> get props => [message];
}

class SearchCubit extends Cubit<SearchState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  SearchCubit({required this.searchMoviesUseCase}) : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchMoviesUseCase(SearchMoviesParams(query: query));

    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (movies) {
        if (movies.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchLoaded(movies: movies, query: query));
        }
      },
    );
  }
}
