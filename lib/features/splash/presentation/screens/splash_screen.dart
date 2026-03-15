// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:movies_app/core/constants/app_colors.dart';
// import 'package:movies_app/core/di/injection_container.dart';
// import 'package:movies_app/core/routes/app_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//     );
//     _controller.forward();
//     _navigate();
//   }

//   Future<void> _navigate() async {
//     await Future.delayed(const Duration(seconds: 3));
//     if (!mounted) return;

//     final prefs = sl<SharedPreferences>();
//     final isOnboarded = prefs.getBool('is_onboarded') ?? false;
//     final isLoggedIn = prefs.getString('api_key') != null;

//     if (!isOnboarded) {
//       context.go(AppRoutes.onboarding);
//     } else if (!isLoggedIn) {
//       context.go(AppRoutes.login);
//     } else {
//       context.go(AppRoutes.home);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Center(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 100.w,
//                 height: 100.w,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   borderRadius: BorderRadius.circular(24.r),
//                 ),
//                 child: Icon(
//                   Icons.movie_filter_rounded,
//                   size: 60.sp,
//                   color: AppColors.white,
//                 ),
//               ),
//               SizedBox(height: 24.h),
//               Text(
//                 'CineYTS',
//                 style: TextStyle(
//                   fontSize: 32.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.white,
//                   letterSpacing: 2,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 'Your Movie Universe',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/di/injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = sl<SharedPreferences>();
    final isOnboarded = prefs.getBool('is_onboarded') ?? false;
    final isLoggedIn = prefs.getString('api_key') != null;

    if (!isOnboarded) {
      context.go(AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/splash/logo2.png',
                    // width: 120.w,
                  ),
                ),
              ),

              // Bottom section - Route + Supervised
              Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/splash/route_text.png',
                      // width: 100.w,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Supervised by Team 5',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
