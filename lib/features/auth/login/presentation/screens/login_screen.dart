import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/core/routes/app_router.dart';
import 'package:movies_app/features/auth/login/presentation/cubit/login_cubit.dart';

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
  bool _obscurePassword = true;
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
                content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Center(child: Image.asset('assets/images/logo2.png',width: 100,height: 100,)),
                  SizedBox(height: 50.h),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset('assets/icons/email.svg',
                            colorFilter: ColorFilter.mode(AppColors.white,  BlendMode.srcIn)),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon:
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset('assets/icons/password.svg',
                            colorFilter: ColorFilter.mode(AppColors.white,  BlendMode.srcIn)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.hint,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  SizedBox(height: 5.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgetPassword),
                      child: Text(
                        'Forgot Password ?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return ElevatedButton(
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
                            ? const CircularProgressIndicator(
                                color: AppColors.white)
                            : const Text('Login'),
                      );
                    },
                  ),
                  SizedBox(height: 22.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' Don’t Have Account ?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.white),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.register),
                        child:  Text(
                          ' Create One ',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.primary,fontWeight: FontWeight.w900),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 27.h),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.primary ,indent: 35,)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('OR',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primary),
                      )
                        ),
                      Expanded(child: Divider(color: AppColors.primary ,endIndent: 35, )),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  ElevatedButton(
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/icongoogle.svg'),
                          SizedBox(width: 16,),
                          Text('Login With Google')
                        ],
                      ),),
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
                        onTap: (){
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                        child: Container(
                           decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedIndex == 0 ? AppColors.primary : Colors.transparent,
                                width: 4,
                              ),
                             borderRadius: BorderRadius.circular(20),),
                            child: SvgPicture.asset('assets/icons/LR.svg',width: 30,height: 30,)),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                            color: selectedIndex == 1 ? AppColors.primary : Colors.transparent,
                            width: 4,),
                            borderRadius: BorderRadius.circular(20),),
                            child: SvgPicture.asset('assets/icons/EG.svg',width: 30,height: 30,)),
                     ),

                    ],
                  ),

                  ),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
