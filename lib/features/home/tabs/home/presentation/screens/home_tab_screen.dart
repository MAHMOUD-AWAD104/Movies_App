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

// class HomeTabScreen extends StatelessWidget {
//   const HomeTabScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Good Evening 👋',
//                             style: Theme.of(context).textTheme.bodyMedium),
//                         Text('Discover Movies',
//                             style: Theme.of(context).textTheme.headlineMedium),
//                       ],
//                     ),
//                     CircleAvatar(
//                       radius: 22.r,
//                       backgroundColor: AppColors.primary,
//                       child: const Icon(Icons.person, color: AppColors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: SizedBox(
//                 height: 40.h,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   children: [
//                     'All',
//                     'Action',
//                     'Comedy',
//                     'Drama',
//                     'Horror',
//                     'Romance',
//                     'Sci-Fi',
//                     'Animation'
//                   ].map((genre) => _GenreChip(genre: genre)).toList(),
//                 ),
//               ),
//             ),
//             SliverPadding(
//               padding: EdgeInsets.all(16.r),
//               sliver: BlocBuilder<HomeCubit, HomeState>(
//                 builder: (context, state) {
//                   if (state is HomeLoading) {
//                     return SliverGrid(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 0.65,
//                         crossAxisSpacing: 12.w,
//                         mainAxisSpacing: 12.h,
//                       ),
//                       delegate: SliverChildBuilderDelegate(
//                         (_, __) => const MovieShimmer(),
//                         childCount: 6,
//                       ),
//                     );
//                   }

//                   if (state is HomeError) {
//                     return SliverToBoxAdapter(
//                       child: Center(
//                         child: Column(
//                           children: [
//                             SizedBox(height: 40.h),
//                             Icon(Icons.error_outline,
//                                 size: 48.sp, color: AppColors.error),
//                             SizedBox(height: 12.h),
//                             Text(state.message,
//                                 style: Theme.of(context).textTheme.bodyMedium),
//                             SizedBox(height: 16.h),
//                             ElevatedButton(
//                               onPressed: () =>
//                                   context.read<HomeCubit>().getMovies(),
//                               child: const Text('Retry'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }

//                   if (state is HomeLoaded) {
//                     return SliverGrid(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 0.65,
//                         crossAxisSpacing: 12.w,
//                         mainAxisSpacing: 12.h,
//                       ),
//                       delegate: SliverChildBuilderDelegate(
//                         (context, index) {
//                           final movie = state.movies[index];
//                           return MovieCard(
//                             key: ValueKey(movie.id),
//                             movie: movie,
//                             onTap: () => context
//                                 .push('${AppRoutes.movieDetails}/${movie.id}'),
//                           );
//                         },
//                         childCount: state.movies.length,
//                       ),
//                     );
//                   }

//                   return const SliverToBoxAdapter(child: SizedBox.shrink());
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _GenreChip extends StatefulWidget {
//   final String genre;
//   const _GenreChip({required this.genre});

//   @override
//   State<_GenreChip> createState() => _GenreChipState();
// }

// class _GenreChipState extends State<_GenreChip> {
//   bool _selected = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(right: 8.w),
//       child: FilterChip(
//         selected: _selected,
//         label: Text(widget.genre),
//         labelStyle: TextStyle(
//           color: _selected ? AppColors.white : AppColors.textSecondary,
//           fontSize: 13.sp,
//         ),
//         backgroundColor: AppColors.surface,
//         selectedColor: AppColors.primary,
//         checkmarkColor: AppColors.white,
//         side: BorderSide.none,
//         onSelected: (value) {
//           setState(() => _selected = value);
//           context.read<HomeCubit>().getMovies(
//                 genre: value && widget.genre != 'All' ? widget.genre : null,
//               );
//         },
//       ),
//     );
//   }
// }

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final _genres = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Animation',
    'Thriller',
  ];

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return GridView.builder(
              padding: EdgeInsets.all(16.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => const MovieShimmer(),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48.sp, color: AppColors.error),
                  SizedBox(height: 12.h),
                  Text(state.message,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().getMovies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return CustomScrollView(
              slivers: [
                // Featured Movie - Available Now
                SliverToBoxAdapter(
                  child: _FeaturedSection(movies: state.movies),
                ),

                // Genres sections
                ...(_genres.map((genre) => SliverToBoxAdapter(
                      child: _GenreSection(genre: genre),
                    ))),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _FeaturedSection extends StatefulWidget {
  final List movies;
  const _FeaturedSection({required this.movies});

  @override
  State<_FeaturedSection> createState() => _FeaturedSectionState();
}

// class _FeaturedSectionState extends State<_FeaturedSection> {
//   final _pageController = PageController(viewportFraction: 0.7);
//   int _currentIndex = 0;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final featured = widget.movies.take(5).toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 20.h),
//         Center(
//           child: Text(
//             'Available Now',
//             style: TextStyle(
//               color: AppColors.white,
//               fontSize: 28.sp,
//               fontWeight: FontWeight.w900,
//               fontStyle: FontStyle.italic,
//               shadows: [
//                 Shadow(
//                   color: Colors.black.withOpacity(0.5),
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 12.h),
//         SizedBox(
//           height: 330.h,
//           child: PageView.builder(
//             controller: _pageController,
//             onPageChanged: (i) => setState(() => _currentIndex = i),
//             itemCount: featured.length,
//             itemBuilder: (context, index) {
//               final movie = featured[index];
//               final isActive = index == _currentIndex;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 8.w,
//                   vertical: isActive ? 0 : 20.h,
//                 ),
//                 child: GestureDetector(
//                   onTap: () =>
//                       context.push('${AppRoutes.movieDetails}/${movie.id}'),
//                   child: Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(16.r),
//                         child: Image.network(
//                           movie.largeCoverImage,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       ),
//                       Positioned(
//                         top: 8.h,
//                         left: 8.w,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 8.w, vertical: 4.h),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.7),
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.star_rounded,
//                                   color: AppColors.primary, size: 14.sp),
//                               SizedBox(width: 4.w),
//                               Text(
//                                 movie.rating.toString(),
//                                 style: TextStyle(
//                                     color: AppColors.white, fontSize: 12.sp),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         SizedBox(height: 16.h),
//         Center(
//           child: Text(
//             'Watch Now',
//             style: TextStyle(
//               color: AppColors.white,
//               fontSize: 28.sp,
//               fontWeight: FontWeight.w900,
//               fontStyle: FontStyle.italic,
//               shadows: [
//                 Shadow(
//                   color: Colors.black.withOpacity(0.5),
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 16.h),
//       ],
//     );
//   }
// }

class _FeaturedSectionState extends State<_FeaturedSection> {
  final _pageController = PageController(viewportFraction: 0.7);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = widget.movies.take(5).toList();

    return SizedBox(
      height: 520.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🔥 Background image of focused movie
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.network(
              featured[_currentIndex].largeCoverImage,
              key: ValueKey(featured[_currentIndex].id),
              fit: BoxFit.cover,
            ),
          ),

          // 🔥 Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),

          // 🔥 Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Image.asset(
                  'assets/images/Available Now.png',
                  width: 150.w,
                  height: 50.h,
                ),
                //   Text(
                //   'Available Now',
                //   style: TextStyle(
                //     color: AppColors.white,
                //     fontSize: 28.sp,
                //     fontWeight: FontWeight.w900,
                //     fontStyle: FontStyle.italic,
                //     shadows: [
                //       Shadow(
                //         color: Colors.black.withOpacity(0.5),
                //         blurRadius: 10,
                //       ),
                //     ],
                //   ),
                // ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 340.h,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemCount: featured.length,
                  itemBuilder: (context, index) {
                    final movie = featured[index];
                    final isActive = index == _currentIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.identity()
                        ..scale(isActive ? 1.0 : 0.85),
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: isActive ? 0 : 40.h,
                      ),
                      child: GestureDetector(
                        onTap: () => context.push(
                          '${AppRoutes.movieDetails}/${movie.id}',
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18.r),
                              child: Image.network(
                                movie.largeCoverImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 8.h,
                              left: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: AppColors.primary,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      movie.rating.toString(),
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child:
                    //  Text(
                    //   'Watch Now',
                    //   style: TextStyle(
                    //     color: AppColors.white,
                    //     fontSize: 28.sp,
                    //     fontWeight: FontWeight.w900,
                    //     fontStyle: FontStyle.italic,
                    //     shadows: [
                    //       Shadow(
                    //         color: Colors.black.withOpacity(0.5),
                    //         blurRadius: 10,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Image.asset(
                  'assets/images/Watch Now.png',
                  width: 150.w,
                  height: 50.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenreSection extends StatelessWidget {
  final String genre;
  const _GenreSection({required this.genre});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<HomeCubit>(),
      child: _GenreSectionContent(genre: genre),
    );
  }
}

class _GenreSectionContent extends StatefulWidget {
  final String genre;
  const _GenreSectionContent({required this.genre});

  @override
  State<_GenreSectionContent> createState() => _GenreSectionContentState();
}

class _GenreSectionContentState extends State<_GenreSectionContent> {
  List _movies = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final cubit = context.read<HomeCubit>();
    final result = await cubit.getMoviesByGenre(genre: widget.genre);
    if (mounted) {
      setState(() {
        _movies = result;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: const LinearProgressIndicator(color: AppColors.primary),
      );
    }

    if (_movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.genre,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<HomeCubit>().getMovies(genre: widget.genre),
                child: Text(
                  'See More →',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _movies.length > 10 ? 10 : _movies.length,
            itemBuilder: (context, index) {
              final movie = _movies[index];
              return GestureDetector(
                onTap: () =>
                    context.push('${AppRoutes.movieDetails}/${movie.id}'),
                child: Container(
                  width: 120.w,
                  margin: EdgeInsets.only(right: 10.w),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          movie.largeCoverImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 6.h,
                        left: 6.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  color: AppColors.primary, size: 11.sp),
                              SizedBox(width: 2.w),
                              Text(
                                movie.rating.toString(),
                                style: TextStyle(
                                    color: AppColors.white, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
