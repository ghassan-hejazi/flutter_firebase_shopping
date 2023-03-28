// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/text_widget.dart';

class ElevatedButtonWidget extends StatelessWidget {
  ElevatedButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);
  Function() onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey,
        minimumSize: Size(double.infinity, AppSizes.r50),
      ),
      child: TextWidget(
        text: text,
        color: AppColors.brown,
        size: FontSizes.sp20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
