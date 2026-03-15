import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../models/onboarding_data.dart';

class OnboardingPageView extends StatelessWidget {
  final List<OnboardingData> pages;
  final PageController controller;
  final ValueChanged<int> onPageChanged;

  const OnboardingPageView({
    super.key,
    required this.pages,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return SizedBox.expand(
          child: Image.asset(
            pages[index].image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(Icons.image_not_supported,
                    color: AppColors.hint, size: 60),
              ),
            ),
          ),
        );
      },
    );
  }
}
