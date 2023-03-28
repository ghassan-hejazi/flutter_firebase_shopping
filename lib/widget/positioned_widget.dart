// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/text_widget.dart';

class PositionedWidget extends StatelessWidget {
  String data;
  double padding;
  double bottomRightRadius;
  PositionedWidget({
    Key? key,
    required this.data,
    required this.padding,
    required this.bottomRightRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSizes.r0,
      left: AppSizes.r0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(AppSizes.r15),
            topLeft: Radius.circular(bottomRightRadius),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: TextWidget(
            text: data,
            color: AppColors.brown,
            size: FontSizes.sp16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
