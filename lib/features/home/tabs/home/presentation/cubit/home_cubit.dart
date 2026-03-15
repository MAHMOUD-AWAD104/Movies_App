import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/home/tabs/home/domain/usecases/get_movies_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetMoviesUseCase getMoviesUseCase;

  HomeCubit({required this.getMoviesUseCase}) : super(HomeInitial());

  Future<void> getMovies({String? genre, int? minimumRating}) async {
    emit(HomeLoading());

    final result = await getMoviesUseCase(
      GetMoviesParams(
        page: 1,
        genre: genre,
        minimumRating: minimumRating,
      ),
    );

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (movies) => emit(
        HomeLoaded(
          movies: movies,
          hasReachedMax: movies.length < 20,
          currentPage: 1,
        ),
      ),
    );
  }

  Future<void> loadMoreMovies() async {
    final currentState = state;
    if (currentState is! HomeLoaded || currentState.hasReachedMax) return;

    final result = await getMoviesUseCase(
      GetMoviesParams(page: currentState.currentPage + 1),
    );

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (movies) {
        if (movies.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            currentState.copyWith(
              movies: [...currentState.movies, ...movies],
              hasReachedMax: movies.length < 20,
              currentPage: currentState.currentPage + 1,
            ),
          );
        }
      },
    );
  }
}
