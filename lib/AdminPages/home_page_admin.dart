// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping/AdminPages/home2_page_admin.dart';
import 'package:shopping/AdminPages/add_products_page.dart';
import 'package:shopping/AdminPages/orders_admin_page.dart';
import 'package:shopping/AuthLoginPages/signin_page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/text_widget.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    List<Widget> pages = <Widget>[
      const HomePageTowAdmin(),
      OrdersAdminPage(),
    ];
    List<String> label = <String>[
      'Page Admin',
      'Orders',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInPage(),
              ),
            );
          },
          icon: Icon(
            Icons.logout,
            color: AppColors.brown,
            size: AppSizes.r28,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: AppSizes.r3,
        title: TextWidget(
          text: label.elementAt(_selectedIndex),
          color: AppColors.brown,
          size: FontSizes.sp18,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => AddProducts()),
                ),
              );
            },
            icon: Icon(
              Icons.add,
              color: AppColors.brown,
              size: AppSizes.r28,
            ),
          ),
        ],
      ),
      body: Center(
        child: pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: AppSizes.r3,
            ),
          ],
        ),
        child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            unselectedLabelStyle: TextStyle(color: AppColors.grey700),
            selectedItemColor: AppColors.blue,
            unselectedItemColor: AppColors.grey700,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_travel),
                label: 'Orders',
              ),
            ]),
      ),
    );
  }
}
