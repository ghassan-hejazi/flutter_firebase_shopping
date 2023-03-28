// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shopping/UsersPages/product_page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/divider_widget.dart';
import 'package:shopping/widget/icon_button_widget.dart';
import 'package:shopping/widget/positioned_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

String search1 = '';

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logoshop.png',
          width: AppSizes.r90,
          height: AppSizes.r90,
        ),
        backgroundColor: AppColors.white,
        elevation: AppSizes.r0,
        leading: IconButtonWidget(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppSizes.r16),
                child: Expanded(
                  child: Container(
                    height: AppSizes.r50,
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(AppSizes.r15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: AppSizes.r12,
                        right: AppSizes.r8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: AppSizes.r28,
                            color: AppColors.grey700,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  search1 = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search here...',
                                labelStyle: TextStyle(
                                  color: AppColors.grey700,
                                  fontSize: FontSizes.sp18,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: AppSizes.r10,
                                  top: AppSizes.r5,
                                  bottom: AppSizes.r5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');

                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;

                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          listOfSearch = docs.where((e) {
                        if (search1.isNotEmpty) {
                          return ((e.data()['title']) as String)
                              .toLowerCase()
                              .startsWith(search1.toLowerCase());
                        }
                        return false;
                      }).toList();

                      return MasonryGridView.count(
                        padding: EdgeInsets.all(AppSizes.r10),
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSizes.r8,
                        crossAxisSpacing: AppSizes.r4,
                        itemCount: listOfSearch.length,
                        itemBuilder: (_, i) {
                          final data = listOfSearch[i].data();
                          //================================ addToCart ========================================================
                          Future addToCart() async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            var currentUser = _auth.currentUser;
                            CollectionReference _collectionRef =
                                FirebaseFirestore.instance
                                    .collection("users-cart-items");
                            return _collectionRef
                                .doc(currentUser!.email)
                                .collection("items")
                                .doc(listOfSearch[i].id)
                                .set({
                              "title": data['title'],
                              "price": data['price'],
                              "imageurl": data['imageurl'],
                              "docId": data['docId'],
                              "isDiscounts": data['isDiscounts'],
                              "discounts": data['discounts'],
                            }).then((value) => print("Added to favourite"));
                          }

                          //=================================================================================================
                          return InkWell(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: ProductPage(snapshot.data!.docs[i].id),
                                withNavBar: false,
                              );
                            },
                            radius: AppSizes.r10,
                            borderRadius: BorderRadius.circular(AppSizes.r15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.r15),
                              ),
                              elevation: AppSizes.r10,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(AppSizes.r15),
                                            topRight:
                                                Radius.circular(AppSizes.r15),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("users-cart-items")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email)
                                          .collection("items")
                                          .where("docId",
                                              isEqualTo: data['docId'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.data == null) {
                                          return const Text("");
                                        }
                                        return Container(
                                          width: AppSizes.r40,
                                          height: AppSizes.r40,
                                          decoration: BoxDecoration(
                                            color:
                                                snapshot.data.docs.length == 0
                                                    ? AppColors.grey
                                                    : AppColors.red,
                                            borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(AppSizes.r15),
                                              topLeft:
                                                  Radius.circular(AppSizes.r15),
                                            ),
                                          ),
                                          child: IconButton(
                                              onPressed: () {
                                                snapshot.data.docs.length == 0
                                                    ? addToCart()
                                                    : print("Already Added");
                                              },
                                              icon: Icon(
                                                Icons
                                                    .add_shopping_cart_outlined,
                                                color: AppColors.brown,
                                                size: AppSizes.r25,
                                              )),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
