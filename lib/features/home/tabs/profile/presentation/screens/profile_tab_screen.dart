import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/routes/app_router.dart';

import '../../../home/domain/entities/movie_entity.dart';
import '../../../home/presentation/screens/widgets/movie_card.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  MovieEntity _mapToMovieEntity(Map<String, dynamic> map) {
    return MovieEntity(
      id: map['id'],
      title: map['title'] ?? '',
      largeCoverImage: map['posterPath'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      year: map['year'] ?? '',
      backgroundImage: '',
      descriptionFull: '',
      genres: [],
      casting: [],
      likerCount: 0,
      runtime: '0',
      screenShot1: '',
      screenShot2: '',
      screenShot3: '',
      summary: '',
        language: '',
        coverImage: '',
        smallCoverImage: '',
        state: '',
        torrents: []
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Text(
              'Please login first',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final userData = snapshot.data?.data() ?? {};
            final String name = userData['username'] ?? 'Movie Lover';
            final String avatar =
                userData['avatar'] ?? 'assets/images/avatar1.png';

            final List<dynamic> watchlist =
            List<dynamic>.from(userData['watchlist'] ?? []);
            final List<dynamic> history =
            List<dynamic>.from(userData['history'] ?? []);

            return Column(
              children: [
                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40.r,
                            backgroundImage: AssetImage(avatar),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _buildStatItem(
                        watchlist.length.toString(),
                        "Watch List",
                      ),
                      const Spacer(),
                      _buildStatItem(
                        history.length.toString(),
                        "History",
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => context.push(AppRoutes.EditProfile),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              context.go(AppRoutes.login);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE82626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: const Icon(Icons.logout, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                DefaultTabController(
                  length: 2,
                  child: Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: AppColors.primary,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: Colors.white,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              icon: Icon(Icons.list, size: 28.sp),
                              text: "Watch List",
                            ),
                            Tab(
                              icon: Icon(Icons.folder, size: 28.sp),
                              text: "History",
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildMoviesGrid(watchlist),
                              _buildMoviesGrid(history),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMoviesGrid(List<dynamic> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_movies_outlined,
              size: 80.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 10.h),
            const Text(
              "No movies added yet",
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(15.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movieMap = movies[index] as Map<String, dynamic>;
        final movie = _mapToMovieEntity(movieMap);

        return MovieCard(
          key: ValueKey(movie.id),
          movie: movie,
          onTap: () => context.push(
            '${AppRoutes.movieDetails}/${movie.id}',
          ),
        );
        /*return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: posterPath.isNotEmpty
                    ? Image.network(
                  posterPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade900,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                    ),
                  ),
                )
                    : Container(
                  color: Colors.grey.shade900,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );*/
      },
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}