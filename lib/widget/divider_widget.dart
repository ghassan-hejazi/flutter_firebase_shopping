
import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: AppSizes.r10,
      thickness: AppSizes.r0,
      color: AppColors.white,
    );
  }
}
