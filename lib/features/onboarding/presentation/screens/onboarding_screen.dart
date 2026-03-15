import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/di/injection_container.dart';
import '../widgets/onboarding_page_view.dart';
import '../widgets/onboarding_bottom_card.dart';
import '../widgets/onboarding_top_bar.dart';
import '../models/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = [
    OnboardingData(
      image: 'assets/images/onboarding/ON1.png',
      title: 'Find Your Next\nFavorite Movie Here',
      subtitle:
          'Get access to a huge library of movies to suit all tastes. You will surely like it.',
      buttonText: 'Explore Now',
    ),
    OnboardingData(
      image: 'assets/images/onboarding/ON2.png',
      title: 'Discover Movies',
      subtitle:
          'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/images/onboarding/ON3.png',
      title: 'Explore All Genres',
      subtitle:
          'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/images/onboarding/ON4.png',
      title: 'Create Watchlists',
      subtitle:
          'Save movies to your watchlist to keep track of what you want to watch next.',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/images/onboarding/ON5.png',
      title: 'Rate, Review, and Learn',
      subtitle:
          'Share your thoughts on the movies you\'ve watched. Help others discover great movies.',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/images/onboarding/ON6.png',
      title: 'Start Watching Now',
      subtitle:
          'Your ultimate movie experience awaits. Dive in and start exploring thousands of films today.',
      buttonText: 'Finish',
    ),
  ];

  Future<void> _finish() async {
    final prefs = sl<SharedPreferences>();
    await prefs.setBool('is_onboarded', true);
    if (mounted) context.go(AppRoutes.login);
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          OnboardingPageView(
            pages: _pages,
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
          ),
          OnboardingTopBar(
            currentPage: _currentPage,
            totalPages: _pages.length,
            onSkip: _finish,
          ),
          OnboardingBottomCard(
            currentPage: _currentPage,
            data: _pages[_currentPage],
            // screenHeight: screenHeight,
            onNext: _next,
            onBack: _back,
          ),
        ],
      ),
    );
  }
}
