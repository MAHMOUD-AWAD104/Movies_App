import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/core/routes/app_router.dart';
import 'package:movies_app/features/auth/login/presentation/cubit/login_cubit.dart';
import '../../../register/presentation/widgets/default_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedIndex = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go(AppRoutes.home);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30.h),
                  Center(
                    child: Image.asset(
                      'assets/images/logo2.png',
                      width: 120.w,
                      height: 120.h,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  DefaultTextFormField(
                    hintText: 'Email',
                    prifixIconImageName: 'email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email is required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  DefaultTextFormField(
                    hintText: 'Password',
                    prifixIconImageName: 'password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgetPassword),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                            color: AppColors.primary, fontSize: 14.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                        ),
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginCubit>().login(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      );
                                }
                              },
                        child: state is LoginLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                    color: Colors.black),
                              )
                            : const Text('Login',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                  SizedBox(height: 22.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don’t Have Account ?',
                          style: TextStyle(
                              color: AppColors.white, fontSize: 14.sp)),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.register),
                        child: Text(
                          ' Create One ',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 27.h),
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: AppColors.primary, indent: 35)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text('OR',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 14.sp)),
                      ),
                      const Expanded(
                          child:
                              Divider(color: AppColors.primary, endIndent: 35)),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/icongoogle.svg'),
                        SizedBox(
                          width: 16,
                        ),
                        Text('Login With Google')
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Container(
                      width: 102,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: AppColors.primary),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      //    padding: const EdgeInsets.all(6),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedIndex == 0
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/LR.svg',
                                  width: 30,
                                  height: 30,
                                )),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedIndex == 1
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/EG.svg',
                                  width: 30,
                                  height: 30,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
