import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/constants/api_constants.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/features/home/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/home/movie_details/presentation/widgets/cast_item.dart';
import 'package:movies_app/features/home/movie_details/presentation/widgets/genre_item.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../tabs/home/presentation/screens/widgets/movie_card.dart';


class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieDetailsCubit>()..getMovieDetails(movieId),
      child: const _MovieDetailsView(),
    );
  }
}

class _MovieDetailsView extends StatelessWidget {

  const _MovieDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsLoading) {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }
        else if (state is MovieDetailsError) {
              return Center(child: Text(state.message));
        }
        else if (state is MovieDetailsLoaded) {
          final movie = state.movie;

          return CustomScrollView(
            slivers: [
              _MovieAppBar(movie: movie),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(movie.title,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineMedium),
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: Text(movie.year,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge),
                      ),
                      SizedBox(height: 8.h),
                      ElevatedButton(onPressed: () {},
                          style:
                          ElevatedButton.styleFrom(backgroundColor: AppColors
                              .red),
                          child: Text('Watch', style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium,)
                      ),
                      SizedBox(height: 8.h),

                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/heart.svg', width: 25,
                                      height: 25,),
                                    const SizedBox(width: 10,),
                                    Text(movie.likerCount.toString(),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge,),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/time.svg', width: 25,
                                      height: 25,),
                                    const SizedBox(width: 10,),
                                    Text(movie.runtime.toString(),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge,),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/star.svg', width: 25,
                                      height: 25,),
                                    const SizedBox(width: 10,),
                                    Text(movie.rating.toString(),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge,),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text('Screen Shots', style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
                          child: CachedNetworkImage(imageUrl: movie.screenShot1,
                            fit: BoxFit.cover,),
                        ),
                      ), SizedBox(height: 8.h),
                      SizedBox(
                        height: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
                          child: CachedNetworkImage(imageUrl: movie.screenShot2,
                            fit: BoxFit.cover,),
                        ),
                      ), SizedBox(height: 8.h),
                      SizedBox(
                        height: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
                          child: CachedNetworkImage(imageUrl: movie.screenShot3,
                            fit: BoxFit.fill,),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Text('Similar', style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge),
                      const SizedBox(height: 8,),

                    ],),
                ),),
              SliverPadding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,),
                  delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final suggestMovie = state.suggestions[index];
                        return MovieCard(
                          key: ValueKey(suggestMovie.id),
                            movie: suggestMovie,
                            onTap: () {});
                      },
                      childCount: state.suggestions.length),
                ),
             ),
              SliverToBoxAdapter(
                child: Padding(padding: const EdgeInsets.only(left: 16,right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Summary',style:Theme
                      .of(context)
                      .textTheme
                      .titleLarge,),
                      const SizedBox(height: 10,),
                      Text(state.movie.descriptionFull,style: Theme.of(context).textTheme.bodyLarge,),
                      const SizedBox(height: 8,),
                      Text('Cast',style:Theme
                          .of(context)
                          .textTheme
                          .titleLarge,),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) => CastItem(cast: movie.casting[index]),
                        separatorBuilder: (_, index) => const SizedBox(height: 8),
                        itemCount: movie.casting.length,
                      ),
                      Text('Genres',style:Theme
                             .of(context)
                             .textTheme
                             .titleLarge,),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: movie.genres.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3,
                        ),
                        itemBuilder: (_, index) {
                          return GenreItem(
                            genre: movie.genres[index],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),

            ],
          );
        }

        else
        return const SizedBox.shrink();
      },
    );
  }
}

class _MovieAppBar extends StatelessWidget {
  final MovieEntity movie;

  const _MovieAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actionsPadding: const EdgeInsets.only(right: 20),
      leadingWidth: 25,
      expandedHeight: 500.h,
      pinned: false,
      backgroundColor: AppColors.background,
      leading: GestureDetector(
          child: Container(
            width: 20,
            padding: const EdgeInsets.only(left: 10.0),
            child: SvgPicture.asset('assets/icons/barrow.svg',),
          ),
      onTap: () {
            Navigator.of(context).pop();
      }),
      actions: [GestureDetector(
          child: SvgPicture.asset('assets/icons/watchlater.svg',),
        onTap: (){

        },)],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl:movie.largeCoverImage.isNotEmpty
                  ? movie.largeCoverImage
                  : movie.backgroundImage,
              fit: BoxFit.fill,
                errorWidget: (_, __, ___) => Image.network(ApiConstants.urlBImage)),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),

            Center(
              child: Image.asset('assets/icons/play.png'),
            ),
          ],
        ),
      ),
    );
  }
}


