import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/core/routes/app_router.dart';
import 'package:movies_app/features/auth/register/presentation/cubit/register_cubit.dart';

import '../widgets/ImageCarousel.dart';
import '../widgets/default_text_form_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final List<String> avatarPaths = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
    'assets/images/avatar7.png',
    'assets/images/avatar8.png',
    'assets/images/avatar9.png',
  ];
  int selectedIndex = 0;
  late String selectedAvatar;

  @override
  void initState() {
    super.initState();
    selectedAvatar = avatarPaths[1]; // لأن initialPage: 1
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.go(AppRoutes.home);
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Register'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  itemCount: avatarPaths.length,
                  itemBuilder: (_, index, ind) =>
                      Imagecarousel(avatarPath: avatarPaths[index]),
                  options: CarouselOptions(
                      height: 115,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.38,
                      viewportFraction: 0.38,
                  initialPage: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        selectedAvatar = avatarPaths[index];
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Avatar',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                DefaultTextFormField(
                  hintText: 'Name',
                  prifixIconImageName: 'name',
                  controller: _usernameCtrl,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                DefaultTextFormField(
                  hintText: 'ُEmail',
                  prifixIconImageName: 'email',
                  controller: _emailCtrl,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                DefaultTextFormField(
                  hintText: 'Password',
                  prifixIconImageName: 'password',
                  controller: _passwordCtrl,
                  validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                  isPassword: true,
                ),
                SizedBox(height: 16.h),
                DefaultTextFormField(
                  hintText: 'Password',
                  prifixIconImageName: 'password',
                  controller: _confirmPasswordCtrl,
                  validator: (v) =>
                      v != _passwordCtrl.text ? 'invalid Password' : null,
                  isPassword: true,
                ),
                SizedBox(
                  height: 16.h,
                ),
                DefaultTextFormField(
                  hintText: 'Phone',
                  prifixIconImageName: 'phone',
                  controller: _phoneCtrl,
                  validator: (v){
                    if (v == null || v.trim().length < 6) {
                      return 'Invalid phone number';
                    }
        }
                ),
                SizedBox(height: 30.h),
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is RegisterLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().register(
                                  username: _usernameCtrl.text.trim(),
                                  email: _emailCtrl.text.trim(),
                                  password: _passwordCtrl.text,
                                  phone: _phoneCtrl.text,
                                  avatarPath: selectedAvatar,
                                    );
                              }
                            },
                      child: state is RegisterLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white)
                          : const Text('Create Account'),
                    );
                  },
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ' Already Have Account?',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.white),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        ' Login ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
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
    );
  }
}
