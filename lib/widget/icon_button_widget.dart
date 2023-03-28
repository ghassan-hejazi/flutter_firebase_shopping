// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shopping/UsersPages/home_Page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class IconButtonWidget extends StatelessWidget {
   const IconButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: HomePage(),
          withNavBar: false,
        );
      },
      icon: Icon(
        Icons.arrow_back_ios,
        size: AppSizes.r25,
      ),
      color: AppColors.brown,
    );
  }
}
