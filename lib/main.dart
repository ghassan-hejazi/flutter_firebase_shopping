// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping/AdminPages/home_page_admin.dart';
import 'package:shopping/AuthLoginPages/signin_page.dart';
import 'package:shopping/UsersPages/home_Page.dart';
import 'package:shopping/widget/image_splash_widget.dart';
import 'package:get_storage/get_storage.dart';

bool? islogin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  Widget homePageAdminUser = await getHomePage();
  await ScreenUtil.ensureScreenSize();

  runApp(MyApp(homePageAdminUser));
}

Future<Widget> getHomePage() async {
  if (islogin == false) {
    return SignInPage();
  } else {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_Id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic> data =
        (querySnapshot.docs.first.data()) as Map<String, dynamic>;
    if (data['role'] == 'admin') {
      return HomePageAdmin();
    } else if (data['role'] == 'user') {
      return HomePage();
    }
    return Scaffold(
      body: Center(
        child: Text('Please try LogIn'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  Widget homePageAdminUser;
  MyApp(this.homePageAdminUser, {super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            home: AnimatedSplashScreen(
                duration: 2000,
                splashIconSize: 200,
                splash: ImageSplashWidget(),
                nextScreen: homePageAdminUser,
                curve: Curves.decelerate,
                splashTransition: SplashTransition.rotationTransition,
                backgroundColor: Colors.white),
          );
        });
  }
}
