import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

import '../../../../../../../core/constants/api_constants.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all( Radius.circular(16.r)),
                child: CachedNetworkImage(
                  imageUrl: movie.largeCoverImage.isNotEmpty
                ? movie.largeCoverImage
                    : movie.backgroundImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                    height: double.infinity,
                    errorWidget: (_, __, ___) => Image.network(ApiConstants.urlBImage)
                    ),
                  ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 9,left: 6),
                    padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.background.withOpacity(0.8)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: TextStyle(
                              color: AppColors.white, fontSize: 16.sp),),
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
