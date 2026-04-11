import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

import '../../../../../../../core/constants/api_constants.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  Future<void> _saveToHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('history')
          .doc(movie.id.toString())
          .set({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.largeCoverImage.isNotEmpty
            ? movie.largeCoverImage
            : movie.backgroundImage,
        'rating': movie.rating,
        'watchedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _saveToHistory();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                child: CachedNetworkImage(
                    imageUrl: movie.largeCoverImage.isNotEmpty
                        ? movie.largeCoverImage
                        : movie.backgroundImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorWidget: (_, __, ___) =>
                        Image.network(ApiConstants.urlBImage)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 9.h, left: 6.w),
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.background.withOpacity(0.8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.rating.toStringAsFixed(1),
                    style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.star_rounded,
                      size: 16.sp, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
