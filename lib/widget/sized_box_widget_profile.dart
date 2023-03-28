// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shopping/widget/text_widget.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class SizedBoxWidgetProfile extends StatelessWidget {
  String text;
  IconData icon;
  SizedBoxWidgetProfile({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.r40,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.blue,
            size: AppSizes.r28,
          ),
          VerticalDivider(
            width: AppSizes.r16,
            thickness: AppSizes.r1,
          ),
          TextWidget(
            text: text,
            size: FontSizes.sp18,
            fontWeight: FontWeight.w700,
            color: AppColors.brown,
          ),
        ],
      ),
    );
  }
}
