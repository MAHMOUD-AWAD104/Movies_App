import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const Center(child: Text("Home Content", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Search Content", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Explore Content", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Profile Content", style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: const Color(0xFFFFBB3B),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/home.svg', width: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/search.svg', width: 24),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/explore.svg', width: 24),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/profile.svg', width: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}