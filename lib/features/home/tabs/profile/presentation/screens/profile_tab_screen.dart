import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/core/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, size: 50.sp, color: AppColors.white),
              ),
              SizedBox(height: 16.h),
              Text('Movie Lover',
                  style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 4.h),
              Text('user@example.com',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 40.h),
              _ProfileOption(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {},
              ),
              SizedBox(height: 16.h),
              _ProfileOption(
                icon: Icons.logout_rounded,
                title: 'Logout',
                color: AppColors.error,
                onTap: () async {
                  final prefs = sl<SharedPreferences>();
                  await prefs.remove('api_key');
                  if (context.mounted) context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.white;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: itemColor),
      title: Text(title, style: TextStyle(color: itemColor, fontSize: 15.sp)),
      trailing: color == null
          ? const Icon(Icons.chevron_right, color: AppColors.hint)
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4.h),
    );
  }
}
