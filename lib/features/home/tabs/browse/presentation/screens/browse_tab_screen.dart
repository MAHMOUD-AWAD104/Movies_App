import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/routes/app_router.dart';
import '../../../../tabs/home/presentation/cubit/home_cubit.dart';
import '../../../../tabs/home/presentation/cubit/home_state.dart';
import '../../../home/presentation/screens/widgets/movie_card.dart';

class BrowseTabScreen extends StatefulWidget {
  const BrowseTabScreen({super.key});

  @override
  State<BrowseTabScreen> createState() => _BrowseTabScreenState();
}

class _BrowseTabScreenState extends State<BrowseTabScreen> {
  String? _selectedGenre;

  static const _genres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Sport',
    'Thriller',
    'War',
    'Western',
  ];

  static const _colors = [
    Color(0xFFE50914),
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF607D8B),
    Color(0xFF795548),
    Color(0xFF3F51B5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _genres.length,
                itemBuilder: (context, index) {
                  final genre = _genres[index];
                  // final color = _colors[index % _colors.length];
                  final color = AppColors.primary;
                  final isSelected = _selectedGenre == genre;

                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedGenre = genre);
                        context.read<HomeCubit>().getMovies(genre: genre);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? color : AppColors.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected ? color : AppColors.primary,
                          ),
                        ),
                        child: Text(
                          genre,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.black : AppColors.primary,
                            fontSize: 13.sp,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Movies Grid
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state is HomeError) {
                    return Center(
                      child: Text(state.message,
                          style: Theme.of(context).textTheme.bodyMedium),
                    );
                  }

                  if (state is HomeLoaded) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                      ),
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MovieCard(
                          movie: movie,
                          onTap: () => context.push(
                            '${AppRoutes.movieDetails}/${movie.id}',
                          ),
                        );
                      },
                    );
                  }

                  return Center(
                    child: Text(
                      'Select a genre to browse movies',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
