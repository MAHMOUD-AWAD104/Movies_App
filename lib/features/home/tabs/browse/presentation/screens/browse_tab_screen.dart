import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/features/home/tabs/home/presentation/cubit/home_cubit.dart';

class BrowseTabScreen extends StatelessWidget {
  const BrowseTabScreen({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Text('Browse by Genre',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemCount: _genres.length,
                itemBuilder: (context, index) {
                  return _GenreTile(genre: _genres[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreTile extends StatelessWidget {
  final String genre;
  const _GenreTile({required this.genre});

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
    final color = _colors[genre.hashCode % _colors.length];

    return GestureDetector(
      onTap: () => context.read<HomeCubit>().getMovies(genre: genre),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.6)],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          genre,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
