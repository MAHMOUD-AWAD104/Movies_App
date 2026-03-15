import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/features/home/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';
import 'package:url_launcher/url_launcher.dart';

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
            backgroundColor: AppColors.background,
            body: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        if (state is MovieDetailsError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text(state.message)),
          );
        }

        if (state is MovieDetailsLoaded) {
          final movie = state.movie;
          return Scaffold(
            backgroundColor: AppColors.background,
            body: CustomScrollView(
              slivers: [
                _MovieAppBar(movie: movie),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                color: AppColors.secondary, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(
                              '${movie.rating}/10',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Icon(Icons.calendar_today_outlined,
                                color: AppColors.hint, size: 14.sp),
                            SizedBox(width: 4.w),
                            Text(movie.year,
                                style: Theme.of(context).textTheme.bodySmall),
                            SizedBox(width: 16.w),
                            Icon(Icons.timer_outlined,
                                color: AppColors.hint, size: 14.sp),
                            SizedBox(width: 4.w),
                            Text('${movie.runtime} min',
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 8.w,
                          children: movie.genres
                              .map((g) => Chip(
                                    label: Text(g,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.white)),
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.2),
                                    side: const BorderSide(
                                        color: AppColors.primary),
                                    padding: EdgeInsets.zero,
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 20.h),
                        Text('Story',
                            style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(height: 8.h),
                        Text(
                          movie.descriptionFull.isNotEmpty
                              ? movie.descriptionFull
                              : movie.summary,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 24.h),
                        Text('Available Torrents',
                            style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(height: 12.h),
                        ...movie.torrents.map((t) => _TorrentCard(torrent: t)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

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
      expandedHeight: 350.h,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: movie.backgroundImage.isNotEmpty
              ? movie.backgroundImage
              : movie.largeCoverImage,
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.background.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TorrentCard extends StatelessWidget {
  final TorrentEntity torrent;
  const _TorrentCard({required this.torrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              torrent.quality,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(torrent.type,
                    style: TextStyle(color: AppColors.white, fontSize: 13.sp)),
                Text(torrent.size,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.green, size: 14.sp),
              Text('${torrent.seeds}',
                  style: TextStyle(color: Colors.green, fontSize: 12.sp)),
              SizedBox(width: 8.w),
              Icon(Icons.arrow_downward, color: AppColors.error, size: 14.sp),
              Text('${torrent.peers}',
                  style: TextStyle(color: AppColors.error, fontSize: 12.sp)),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(torrent.url);
                  if (await canLaunchUrl(uri)) launchUrl(uri);
                },
                child: Icon(Icons.download_rounded,
                    color: AppColors.primary, size: 22.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
