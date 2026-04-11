import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/auth/forget_password/presentation/screens/forget_password_screen.dart';
import 'package:movies_app/features/auth/login/presentation/screens/login_screen.dart';
import 'package:movies_app/features/auth/register/presentation/screens/register_screen.dart';
import 'package:movies_app/features/home/movie_details/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/features/home/presentation/screens/home_screen.dart';
import 'package:movies_app/features/home/tabs/profile/presentation/screens/edit_profile_screen.dart';
import 'package:movies_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movies_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:movies_app/features/home/tabs/home/domain/usecases/get_movies_usecase.dart';
import '../../features/home/tabs/browse/presentation/screens/browse_tab_screen.dart';
import '../../features/home/tabs/home/presentation/cubit/home_cubit.dart';
import '../di/injection_container.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.movieDetails}/:id',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailsScreen(movieId: movieId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.browse}/:genre',
        builder: (context, state) {
          final genre = state.pathParameters['genre']!;
          return BlocProvider(
            create: (_) => HomeCubit(
              getMoviesUseCase: sl<GetMoviesUseCase>(),
            ),
            child: BrowseTabScreen(genre: genre),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.EditProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String home = '/home';
  static const String movieDetails = '/movie-details';
  static const String EditProfile = '/edit-profile';
  static const String browse = '/browse';

}
