import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/home/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieEntity movie;
  final List<MovieEntity> suggestions;

  const MovieDetailsLoaded({required this.movie, this.suggestions = const []});

  @override
  List<Object?> get props => [movie, suggestions];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  const MovieDetailsError({required this.message});
  @override
  List<Object?> get props => [message];
}

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;

  MovieDetailsCubit({required this.getMovieDetailsUseCase})
      : super(MovieDetailsInitial());

  Future<void> getMovieDetails(int movieId) async {
    emit(MovieDetailsLoading());

    final result = await getMovieDetailsUseCase(movieId);

    result.fold(
      (failure) => emit(MovieDetailsError(message: failure.message)),
      (movie) => emit(MovieDetailsLoaded(movie: movie)),
    );
  }
}
