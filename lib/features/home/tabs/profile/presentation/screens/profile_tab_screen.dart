import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/routes/app_router.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Firestore
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                var userData = snapshot.data?.data() as Map<String, dynamic>?;
                String name = userData?['username'] ?? 'Movie Lover';
                String avatar =
                    userData?['avatar'] ?? 'assets/images/avatar1.png';

                return Padding(
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
                          Text(name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Spacer(),
                      _buildStatItem("12", "Wish List"),
                      const Spacer(),
                      _buildStatItem("10", "History"),
                      const Spacer(),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),

            //Edit & Logout
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
                            borderRadius: BorderRadius.circular(10.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: const Text("Edit Profile",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) context.go(AppRoutes.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE82626),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: const Icon(Icons.logout, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // History & Watch List Tabs
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
                            text: "Watch List"),
                        Tab(
                            icon: Icon(Icons.folder, size: 28.sp),
                            text: "History"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildMoviesGrid("wishlist"),
                          _buildMoviesGrid("history"),
                        ],
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
  }

  // Firestore
  Widget _buildMoviesGrid(String collectionPath) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid)
          .collection(collectionPath)
          .orderBy('watchedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_movies_outlined,
                    size: 80.sp, color: AppColors.primary),
                SizedBox(height: 10.h),
                const Text("No movies added yet",
                    style: TextStyle(color: Colors.white54)),
              ],
            ),
          );
        }

        var movies = snapshot.data!.docs;
        return GridView.builder(
          padding: EdgeInsets.all(15.r),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            var movie = movies[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${movie['posterPath']}",
                fit: BoxFit.cover,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
      ],
    );
  }
}
