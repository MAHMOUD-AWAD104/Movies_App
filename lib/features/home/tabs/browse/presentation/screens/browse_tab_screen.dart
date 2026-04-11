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
  final String genre;

  const BrowseTabScreen({super.key,required this.genre});

  @override
  State<BrowseTabScreen> createState() => _BrowseTabScreenState();
}

class _BrowseTabScreenState extends State<BrowseTabScreen> {
  String? _selectedGenre ;
  final ScrollController _genreScrollController = ScrollController();


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


  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.genre;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedGenre();
      context.read<HomeCubit>().getMovies(genre: widget.genre);
    });
  }

  void _scrollToSelectedGenre() {
    final index = _genres.indexOf(_selectedGenre ?? '');
    if (index == -1 || !_genreScrollController.hasClients) return;

    const itemWidth =  100.0;
    final offset = index * itemWidth;

    _genreScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _genreScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SizedBox(
                    height: 40.h,
                    child: ListView.builder(
                      controller: _genreScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(right: 16.w),
                      itemCount: _genres.length,
                      itemBuilder: (context, index) {
                        final genre = _genres[index];
                        final color = AppColors.primary;
                        final isSelected = _selectedGenre == genre;

                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedGenre = genre);
                              _scrollToSelectedGenre();
                              context.read<HomeCubit>().getMovies(genre: genre);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? color : AppColors.background,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: color),
                              ),
                              child: Text(
                                genre,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.background
                                      : AppColors.primary,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 25.h),

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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                      ),
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MovieCard(
                          key: ValueKey(movie.id),
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
