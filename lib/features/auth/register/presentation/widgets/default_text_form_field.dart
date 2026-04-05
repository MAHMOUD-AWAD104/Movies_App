import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/constants/app_colors.dart';
class DefaultTextFormField extends StatefulWidget{
  String hintText;
  void Function(String)? onChanged;
  TextEditingController? controller;
  String? Function(String?)? validator;
  String? prifixIconImageName;
  bool isPassword ;


  DefaultTextFormField({
    required this.hintText,
    this.onChanged,
    this.validator,
    this.controller,
    this.prifixIconImageName,
    this.isPassword = false,
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {

  late bool isObscure = widget.isPassword ? true : false;
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.prifixIconImageName == null ? null
              : Padding(
            padding:  EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/icons/${widget.prifixIconImageName}.svg',
              colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn,
              ),
              width: 26,
              height: 26,
                  ),
          ),
          suffixIcon:  widget.isPassword? IconButton(
              onPressed:(){
                isObscure = !isObscure;
                setState(() {});
              },
              icon: Icon(isObscure?  Icons.visibility_outlined : Icons.visibility_off_outlined
                , color: AppColors.white,)):null
      ),
      onChanged: widget.onChanged,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: isObscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),

    );
  }
}