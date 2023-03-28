// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shopping/AdminPages/edit%20_products_page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/divider_widget.dart';
import 'package:shopping/widget/positioned_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class HomePageTowAdmin extends StatefulWidget {
  const HomePageTowAdmin({Key? key}) : super(key: key);

  @override
  State<HomePageTowAdmin> createState() => _HomePageTowAdminState();
}

class _HomePageTowAdminState extends State<HomePageTowAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Text('Error = ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return MasonryGridView.count(
              padding: EdgeInsets.all(AppSizes.r10),
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.r8,
              crossAxisSpacing: AppSizes.r4,
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return InkWell(
                  onTap: () {},
                  radius: AppSizes.r10,
                  borderRadius: BorderRadius.circular(AppSizes.r15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r15),
                    ),
                    elevation: AppSizes.r10,
                    child: SizedBox(
                      height: 290,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Column(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(AppSizes.r15),
                                    topRight: Radius.circular(AppSizes.r15),
                                  ),
                                ),
                                width: double.infinity,
                                height: AppSizes.r160,
                                child: Image.network(
                                  '${data['imageurl']}',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const DividerWidget(),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: AppSizes.r8,
                                  left: AppSizes.r8,
                                  bottom: AppSizes.r8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    SizedBox(
                                      height: AppSizes.r16,
                                    ),
                                    if (data['isDiscounts'] == true)
                                      Row(
                                        children: [
                                          TextWidget(
                                            text: '\$',
                                            color: AppColors.green,
                                            size: FontSizes.sp16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          TextWidgetTow(
                                            text:
                                                '${double.parse(data['price'])}',
                                          ),
                                          TextWidget(
                                            text:
                                                ' - ${double.parse(data['price']) - double.parse(data['price']) * double.parse(data['discounts']) / 100}',
                                            color: AppColors.black,
                                            size: FontSizes.sp16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    if (data['isDiscounts'] == false)
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
                                                  '${double.parse(data['price'])}',
                                              color: AppColors.black,
                                              size: FontSizes.sp16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (data['isDiscounts'] == true)
                            PositionedWidget(
                              data: '-${data['discounts']}%',
                              padding: AppSizes.r6,
                              bottomRightRadius: AppSizes.r15,
                            ),
                          Positioned(
                            bottom: AppSizes.r0,
                            left: AppSizes.r0,
                            child: Container(
                              width: AppSizes.r40,
                              height: AppSizes.r40,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(AppSizes.r15),
                                  topRight: Radius.circular(AppSizes.r15),
                                ),
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(snapshot.data!.docs[i].id)
                                        .delete()
                                        .then((value) => print("User Deleted"))
                                        .catchError((error) => print(
                                            "Failed to delete user: $error"));
                                    await FirebaseStorage.instance
                                        .refFromURL(
                                            snapshot.data!.docs[i]['imageurl'])
                                        .delete();
                                    FirebaseFirestore.instance
                                        .collection("users-cart-items")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .collection("items")
                                        .doc(snapshot.data!.docs[i].id)
                                        .delete()
                                        .then((value) => print("User Deleted"))
                                        .catchError((error) => print(
                                            "Failed to delete user: $error"));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.brown,
                                    size: AppSizes.r25,
                                  )),
                            ),
                          ),
                          Positioned(
                            bottom: AppSizes.r0,
                            right: AppSizes.r0,
                            child: Container(
                              width: AppSizes.r40,
                              height: AppSizes.r40,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(AppSizes.r15),
                                  topRight: Radius.circular(AppSizes.r15),
                                ),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: ((context) {
                                      debugPrint(
                                          'mohammed : ${snapshot.data!.docs[i].id}');
                                      return EditProducts(
                                        snapshot.data!.docs[i].id,
                                        list: data,
                                      );
                                    })));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.brown,
                                    size: AppSizes.r25,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
