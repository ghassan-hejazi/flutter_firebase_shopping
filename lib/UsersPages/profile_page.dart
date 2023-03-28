// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_constructors_in_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shopping/AuthLoginPages/signin_page.dart';
import 'package:shopping/UsersPages/edit_profile_page.dart';
import 'package:shopping/widget/icon_button_widget.dart';
import 'package:shopping/widget/sized_box_widget_profile.dart';
import 'package:shopping/widget/text_widget.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButtonWidget(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: AppSizes.r3,
        title: TextWidget(
          text: 'Profile',
          color: AppColors.brown,
          size: FontSizes.sp18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('user_Id',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  Map<String, dynamic> data = snapshot.data!.docs.first.data();
                  return Padding(
                    padding: EdgeInsets.all(AppSizes.r16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.grey,
                          radius: AppSizes.r60,
                          child: Icon(
                            Icons.person,
                            size: AppSizes.r60,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: AppSizes.r32),
                        SizedBoxWidgetProfile(
                          text: '${data['username']}',
                          icon: Icons.person,
                        ),
                        Divider(),
                        SizedBoxWidgetProfile(
                          text: '${data['email']}',
                          icon: Icons.email,
                        ),
                        Divider(),
                        SizedBoxWidgetProfile(
                          text: '${data['country']}',
                          icon: Icons.location_on,
                        ),
                        Divider(),
                        SizedBoxWidgetProfile(
                          text: '${data['city']}',
                          icon: Icons.location_on,
                        ),
                        Divider(),
                        SizedBoxWidgetProfile(
                          text: '${data['streetandregion']}',
                          icon: Icons.location_on,
                        ),
                        SizedBox(height: AppSizes.r40),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: SignInPage(),
                              withNavBar: false,
                            );
                          },
                          label: TextWidget(
                            text: 'Logout',
                            color: AppColors.brown,
                            size: FontSizes.sp18,
                            fontWeight: FontWeight.w700,
                          ),
                          icon: Icon(
                            Icons.logout,
                            color: AppColors.brown,
                            size: AppSizes.r25,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey,
                            minimumSize: Size(AppSizes.r180, AppSizes.r40),
                          ),
                        ),
                        SizedBox(height: AppSizes.r32),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => EditProfilePage(
                                      snapshot.data!.docs[i].id,
                                      list: data,
                                    )),
                              ),
                            );
                          },
                          child: TextWidget(
                            text: 'Edit Profile',
                            color: AppColors.brown,
                            size: FontSizes.sp18,
                            fontWeight: FontWeight.w700,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey,
                            minimumSize: Size(AppSizes.r180, AppSizes.r40),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
