// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class InKWellWidget extends StatelessWidget {
  Widget page;
  String image;
  InKWellWidget({
    Key? key,
    required this.page,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppSizes.r4, left: AppSizes.r0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) {
                return page;
              }),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppSizes.r15),
        child: Card(
          color: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r15),
          ),
          elevation: AppSizes.r3,
          child: Image.asset(
            'assets/images/$image',
            width: AppSizes.r60,
            height: AppSizes.r60,
          ),
        ),
      ),
    );
  }
}
