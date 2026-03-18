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
    // final isOnboarded = prefs.getBool('is_onboarded') ?? false;
    final isLoggedIn = prefs.getString('api_key') != null;

    if (!isLoggedIn) {
      context.go(AppRoutes.onboarding);
      // } else if (!isLoggedIn) {
      //   context.go(AppRoutes.login);
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
