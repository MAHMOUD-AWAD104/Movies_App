import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/routes/app_router.dart';
import 'package:movies_app/features/home/tabs/home/presentation/screens/widgets/movie_card.dart';
import 'package:movies_app/features/home/tabs/search/presentation/cubit/search_cubit.dart';
import 'package:flutter_svg/svg.dart';

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
              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (query) =>
                    context.read<SearchCubit>().searchMovies(query),
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: Padding(
                    padding:  EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/search.svg',
                      colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn,
                      ),
                      width: 26,
                      height: 26,
                    ),
                  ),
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
                          Image.asset(
                            'assets/images/popcorn.png',
                            width: 150.w,
                          ),
                          SizedBox(height: 16.h),
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
