// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class TextWidget extends StatelessWidget {
  String text;
  Color color;
  double size;
  FontWeight fontWeight;

  TextWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.size,
    required this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

class TextWidgetTow extends StatelessWidget {
  String text;
  TextWidgetTow({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: FontSizes.sp16,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        decorationStyle: TextDecorationStyle.solid,
        decoration: TextDecoration.lineThrough,
        decorationThickness: 2,
        decorationColor: Colors.black,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
