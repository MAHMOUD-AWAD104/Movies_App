import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class GenreItem extends StatelessWidget{
  String genre;
  GenreItem({required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 5,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: Center(child: Text(genre,style: Theme.of(context).textTheme.titleMedium)),
    );
  }

}