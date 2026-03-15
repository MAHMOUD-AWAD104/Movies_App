import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../models/onboarding_data.dart';

class OnboardingBottomCard extends StatelessWidget {
  final int currentPage;
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const OnboardingBottomCard({
    super.key,
    required this.currentPage,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.r),
            topRight: Radius.circular(32.r),
          ),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 36.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              data.subtitle,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 15.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                data.buttonText,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ),
            if (currentPage > 1) ...[
              SizedBox(height: 12.h),
              OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: Size(double.infinity, 52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
