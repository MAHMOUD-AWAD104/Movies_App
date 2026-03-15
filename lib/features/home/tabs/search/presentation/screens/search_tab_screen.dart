import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/routes/app_router.dart';
import 'package:movies_app/features/home/tabs/home/presentation/screens/widgets/movie_card.dart';
import 'package:movies_app/features/home/tabs/search/presentation/cubit/search_cubit.dart';

class SearchTabScreen extends StatefulWidget {
  const SearchTabScreen({super.key});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
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
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Text('Search',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (query) =>
                    context.read<SearchCubit>().searchMovies(query),
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.hint),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.hint),
                          onPressed: () {
                            _searchCtrl.clear();
                            context.read<SearchCubit>().searchMovies('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_rounded,
                              size: 80.sp, color: AppColors.hint),
                          SizedBox(height: 16.h),
                          Text('Search for your favorite movie',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    );
                  }

                  if (state is SearchLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state is SearchEmpty) {
                    return Center(
                      child: Text('No results found',
                          style: Theme.of(context).textTheme.bodyMedium),
                    );
                  }

                  if (state is SearchLoaded) {
                    return GridView.builder(
                      padding: EdgeInsets.all(16.r),
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
                          onTap: () => context
                              .push('${AppRoutes.movieDetails}/${movie.id}'),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
