// ignore_for_file: prefer_const_constructors_in_immutables, sized_box_for_whitespace, non_constant_identifier_names, prefer_const_constructors, unnecessary_string_interpolations, avoid_print, use_build_context_synchronously, unused_local_variable, no_leading_underscores_for_local_identifiers, file_names, unused_element

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shopping/UsersPages/cart_page.dart';
import 'package:shopping/UsersPages/home_tow_page.dart';
import 'package:shopping/UsersPages/orders_page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);
    List<Widget> _pages = <Widget>[
      HomeTowPage(),
      CartPage(),
      OrdersPage(),
      ProfilePage(),
    ];

    return Scaffold(
        body: PersistentTabView(
      decoration: NavBarDecoration(
        border: Border(
          top: BorderSide(
            width: AppSizes.r1,
          ),
        ),
      ),
      controller: _controller,
      context,
      screens: _pages,
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: 'Home',
          activeColorPrimary: AppColors.blue,
          inactiveColorPrimary: AppColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: 'Cart',
          activeColorPrimary: AppColors.blue,
          inactiveColorPrimary: AppColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.card_travel_rounded),
          title: 'My Orders',
          activeColorPrimary: AppColors.blue,
          inactiveColorPrimary: AppColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'Profile',
          activeColorPrimary: AppColors.blue,
          inactiveColorPrimary: AppColors.black,
        ),
      ],
      confineInSafeArea: false,
      backgroundColor: AppColors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: false,
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: false,
      popActionScreens: PopActionScreensType.once,
      popAllScreensOnTapAnyTabs: true,
      navBarStyle:
          NavBarStyle.style13, // Choose the nav bar style with this property.
    ));
  }
}
