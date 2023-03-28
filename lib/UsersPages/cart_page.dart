// ignore_for_file: prefer_const_constructors_in_immutables, sized_box_for_whitespace, non_constant_identifier_names, prefer_const_constructors, unnecessary_string_interpolations, avoid_print, use_build_context_synchronously, unused_local_variable, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shopping/UsersPages/product_page.dart';
import 'package:shopping/widget/divider_widget.dart';
import 'package:shopping/widget/icon_button_widget.dart';
import 'package:shopping/widget/positioned_widget.dart';
import 'package:shopping/widget/text_widget.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButtonWidget(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: AppSizes.r3,
        title: TextWidget(
          text: 'Cart',
          color: AppColors.brown,
          size: FontSizes.sp18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-cart-items")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              debugPrint('mohammed : ${docs}');

              return MasonryGridView.count(
                padding: EdgeInsets.all(AppSizes.r10),
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.r8,
                crossAxisSpacing: AppSizes.r4,
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final data = docs[i].data();
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return ProductPage(snapshot.data!.docs[i].id);
                      })));
                    },
                    radius: AppSizes.r10,
                    borderRadius: BorderRadius.circular(AppSizes.r15),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.r15),
                      ),
                      elevation: AppSizes.r15,
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
                              DividerWidget(),
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
                          Container(
                            width: AppSizes.r40,
                            height: AppSizes.r40,
                            decoration: BoxDecoration(
                              color: snapshot.data.docs.length == 0
                                  ? AppColors.green
                                  : AppColors.red,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(AppSizes.r15),
                                topLeft: Radius.circular(AppSizes.r15),
                              ),
                            ),
                            child: IconButton(
                                onPressed: () {
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
                                  Icons.add_shopping_cart_outlined,
                                  color: AppColors.brown,
                                  size: AppSizes.r25,
                                )),
                          ),
                        ],
                      ),
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
