import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/routes/app_router.dart';
import 'package:movies_app/features/home/tabs/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/home/tabs/home/presentation/cubit/home_state.dart';
import 'widgets/movie_card.dart';
import 'widgets/movie_shimmer.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Evening 👋',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Discover Movies',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.person, color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    'All',
                    'Action',
                    'Comedy',
                    'Drama',
                    'Horror',
                    'Romance',
                    'Sci-Fi',
                    'Animation'
                  ].map((genre) => _GenreChip(genre: genre)).toList(),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.r),
              sliver: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, __) => const MovieShimmer(),
                        childCount: 6,
                      ),
                    );
                  }

                  if (state is HomeError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 40.h),
                            Icon(Icons.error_outline,
                                size: 48.sp, color: AppColors.error),
                            SizedBox(height: 12.h),
                            Text(state.message,
                                style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<HomeCubit>().getMovies(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final movie = state.movies[index];
                          return MovieCard(
                            movie: movie,
                            onTap: () => context
                                .push('${AppRoutes.movieDetails}/${movie.id}'),
                          );
                        },
                        childCount: state.movies.length,
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreChip extends StatefulWidget {
  final String genre;
  const _GenreChip({required this.genre});

  @override
  State<_GenreChip> createState() => _GenreChipState();
}

class _GenreChipState extends State<_GenreChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        selected: _selected,
        label: Text(widget.genre),
        labelStyle: TextStyle(
          color: _selected ? AppColors.white : AppColors.textSecondary,
          fontSize: 13.sp,
        ),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        checkmarkColor: AppColors.white,
        side: BorderSide.none,
        onSelected: (value) {
          setState(() => _selected = value);
          context.read<HomeCubit>().getMovies(
                genre: value && widget.genre != 'All' ? widget.genre : null,
              );
        },
      ),
    );
  }
}
