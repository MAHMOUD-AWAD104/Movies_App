import 'package:get_it/get_it.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/auth/forget_password/data/repos/forget_password_repo_impl.dart';
import 'package:movies_app/features/auth/forget_password/domain/repos/forget_password_repo.dart';
import 'package:movies_app/features/auth/forget_password/domain/usecases/forget_password_usecase.dart';
import 'package:movies_app/features/auth/forget_password/presentation/cubit/forget_password_cubit.dart';
import 'package:movies_app/features/auth/login/data/repos/login_repo_impl.dart';
import 'package:movies_app/features/auth/login/domain/repos/login_repo.dart';
import 'package:movies_app/features/auth/login/domain/usecases/login_usecase.dart';
import 'package:movies_app/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:movies_app/features/auth/register/data/repos/register_repo_impl.dart';
import 'package:movies_app/features/auth/register/domain/repos/register_repo.dart';
import 'package:movies_app/features/auth/register/domain/usecases/register_usecase.dart';
import 'package:movies_app/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:movies_app/features/home/movie_details/data/repos/movie_details_repo_impl.dart';
import 'package:movies_app/features/home/movie_details/domain/repos/movie_details_repo.dart';
import 'package:movies_app/features/home/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies_app/features/home/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/home/tabs/home/data/repos/movies_repo_impl.dart';
import 'package:movies_app/features/home/tabs/home/domain/repos/movies_repo.dart';
import 'package:movies_app/features/home/tabs/home/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/home/tabs/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/home/tabs/search/data/repos/search_repo_impl.dart';
import 'package:movies_app/features/home/tabs/search/domain/repos/search_repo.dart';
import 'package:movies_app/features/home/tabs/search/domain/usecases/search_movies_usecase.dart';
import 'package:movies_app/features/home/tabs/search/presentation/cubit/search_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  _initAuth();
  _initHome();
}

void _initAuth() {
  // Login
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton<LoginRepo>(
      () => LoginRepoImpl(apiClient: sl(), networkInfo: sl()));

  // Register
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<RegisterRepo>(() =>
      RegisterRepoImpl(apiClient: sl(), networkInfo: sl()) as RegisterRepo);

  // Forget Password
  sl.registerFactory(() => ForgetPasswordCubit(forgetPasswordUseCase: sl()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
  sl.registerLazySingleton<ForgetPasswordRepo>(() =>
      ForgetPasswordRepoImpl(apiClient: sl(), networkInfo: sl())
          as ForgetPasswordRepo);
}

void _initHome() {
  // Home
  sl.registerFactory(() => HomeCubit(getMoviesUseCase: sl()));
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton<MoviesRepo>(
      () => MoviesRepoImpl(apiClient: sl(), networkInfo: sl()));

  // Search
  sl.registerFactory(() => SearchCubit(searchMoviesUseCase: sl()));
  sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));
  sl.registerLazySingleton<SearchRepo>(
      () => SearchRepoImpl(apiClient: sl(), networkInfo: sl()));

  // Movie Details
  sl.registerFactory(() => MovieDetailsCubit(getMovieDetailsUseCase: sl()));
  sl.registerLazySingleton(() => GetMovieDetailsUseCase(sl()));
  sl.registerLazySingleton<MovieDetailsRepo>(
      () => MovieDetailsRepoImpl(apiClient: sl(), networkInfo: sl()));
}
