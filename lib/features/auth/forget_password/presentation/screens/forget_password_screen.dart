import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/di/injection_container.dart';
import 'package:movies_app/features/auth/forget_password/presentation/cubit/forget_password_cubit.dart';

import '../../../register/presentation/widgets/default_text_form_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgetPasswordCubit>(),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatefulWidget {
  const _ForgetPasswordView();

  @override
  State<_ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<_ForgetPasswordView> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: Colors.green),
          );
          context.pop();
        } else if (state is ForgetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(leading: const BackButton(),
          title: Text('Forget Password'),),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Image.asset('assets/images/forgot.png'),
              SizedBox(height: 25.h),
              DefaultTextFormField(
                hintText: 'ُEmail',
                prifixIconImageName: 'email',
                controller: _emailCtrl,
                validator: (value){
                  if(value == null || value.length<10){
                    return 'Invalid email';
                  }
                  return null;
                },),
              SizedBox(height: 25.h),
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is ForgetPasswordLoading
                        ? null
                        : () {
                            if (_emailCtrl.text.isNotEmpty) {
                              context
                                  .read<ForgetPasswordCubit>()
                                  .forgetPassword(_emailCtrl.text.trim());
                            }
                          },
                    child: state is ForgetPasswordLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.white)
                        : const Text('Verify Email'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
