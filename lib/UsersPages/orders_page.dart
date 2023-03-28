// ignore_for_file: prefer_const_constructors_in_immutables, sized_box_for_whitespace, non_constant_identifier_names, prefer_const_constructors, unnecessary_string_interpolations, avoid_print, use_build_context_synchronously, unused_local_variable, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/icon_button_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButtonWidget(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: AppSizes.r3,
        title: TextWidget(
          text: 'My Orders',
          color: AppColors.brown,
          size: FontSizes.sp18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-Orders-items")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              debugPrint('mohammed : ${docs}');
              return ListView.separated(
                padding: EdgeInsets.all(AppSizes.r10),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: AppSizes.r1,
                    height: AppSizes.r25,
                  );
                },
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final data = docs[i].data();
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.r15),
                        ),
                        child: Image.network(
                          '${data['imageurl']}',
                          fit: BoxFit.fill,
                          width: AppSizes.r160,
                          height: AppSizes.r160,
                        ),
                      ),
                      SizedBox(
                        width: AppSizes.r16,
                      ),
                      SizedBox(
                        width: AppSizes.r160,
                        height: AppSizes.r170,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    text: '${data['title']}',
                                    color: AppColors.brown,
                                    size: FontSizes.sp14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextWidget(
                                  text: '\$',
                                  color: AppColors.green,
                                  size: FontSizes.sp16,
                                  fontWeight: FontWeight.w700,
                                ),
                                Expanded(
                                  child: TextWidget(
                                    text:
                                        '${data['price'] * data['countProducts']}',
                                    color: AppColors.black,
                                    size: FontSizes.sp14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextWidget(
                                  text: 'number : ',
                                  color: AppColors.green,
                                  size: FontSizes.sp14,
                                  fontWeight: FontWeight.w600,
                                ),
                                Expanded(
                                  child: TextWidget(
                                    text: 'x${data['countProducts']}',
                                    color: AppColors.black,
                                    size: FontSizes.sp16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextWidget(
                                  text: 'Color : ',
                                  color: AppColors.green,
                                  size: FontSizes.sp14,
                                  fontWeight: FontWeight.w600,
                                ),
                                CircleAvatar(
                                  radius: AppSizes.r12,
                                  backgroundColor: Color(data['color']),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextWidget(
                                  text: 'Size : ',
                                  color: AppColors.green,
                                  size: FontSizes.sp14,
                                  fontWeight: FontWeight.w600,
                                ),
                                Expanded(
                                  child: TextWidget(
                                    text: '${data['size_user']}',
                                    color: AppColors.black,
                                    size: FontSizes.sp16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(AppSizes.r0),
                              dense: true,
                              title: TextWidget(
                                text: 'DateOrder',
                                color: AppColors.green,
                                size: FontSizes.sp14,
                                fontWeight: FontWeight.w600,
                              ),
                              subtitle: Text(
                                '${data['dateOrder']}',
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
