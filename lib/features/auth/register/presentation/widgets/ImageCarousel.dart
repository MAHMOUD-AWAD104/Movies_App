import 'package:flutter/cupertino.dart';

class Imagecarousel extends StatelessWidget {
  final String avatarPath ;

  Imagecarousel({required this.avatarPath});

  @override
  Widget build(BuildContext context) {
    return  Image.asset(avatarPath,
        fit: BoxFit.cover,
    );
  }

}