import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/features/home/tabs/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/home/tabs/home/presentation/screens/home_tab_screen.dart';
import 'package:movies_app/features/home/tabs/profile/presentation/screens/profile_tab_screen.dart';
import 'package:movies_app/features/home/tabs/search/presentation/cubit/search_cubit.dart';
import 'package:movies_app/features/home/tabs/browse/presentation/screens/browse_tab_screen.dart';
import 'package:movies_app/features/home/tabs/search/presentation/screens/search_tab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeCubit>()..getMovies()),
        BlocProvider(create: (_) => sl<SearchCubit>()),
      ],
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: _tabs,
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.only(right: 9,left: 9,bottom: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: NavigationBar(
              height: 60,
              backgroundColor: AppColors.surface,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
             indicatorColor: Colors.transparent,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              destinations:  [
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/home.svg'),
                  selectedIcon: SvgPicture.asset('assets/icons/home.svg',
                    colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/search.svg'),
                  selectedIcon: SvgPicture.asset('assets/icons/search.svg',
                    colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/browser.svg'),
                  selectedIcon: SvgPicture.asset('assets/icons/browser.svg',
                    colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),),
                  label: 'Browse',
                ),
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/profile.svg'),
                  selectedIcon: SvgPicture.asset('assets/icons/profile.svg',
                    colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: const Color(0xFFFFBB3B),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 24, height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/search.png', width: 24, height: 24),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/explore.png', width: 24, height: 24),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/profile.png', width: 24, height: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MovieItemCard extends StatelessWidget {
  const MovieItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/bg.png',
          height: 210,
          width: 140,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}