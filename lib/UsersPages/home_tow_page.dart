// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_constructors_in_immutables, unused_field, prefer_final_fields, unused_element, no_leading_underscores_for_local_identifiers, avoid_print, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shopping/CategoriesPages/clothes_page.dart';
import 'package:shopping/CategoriesPages/dresses_page.dart';
import 'package:shopping/CategoriesPages/electronics_page.dart';
import 'package:shopping/CategoriesPages/furniture_page.dart';
import 'package:shopping/CategoriesPages/shoes_page.dart';
import 'package:shopping/CategoriesPages/trouser_page.dart';
import 'package:shopping/UsersPages/product_page.dart';
import 'package:shopping/UsersPages/search_page.dart';
import 'package:shopping/widget/stream_builder_widget.dart';
import 'package:shopping/widget/inkwell_widget.dart';
import 'package:shopping/widget/text_widget.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeTowPage extends StatefulWidget {
  HomeTowPage({Key? key}) : super(key: key);

  @override
  State<HomeTowPage> createState() => _HomeTowPageState();
}

class _HomeTowPageState extends State<HomeTowPage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: SearchPage(),
                  withNavBar: false,
                );
              },
              icon: Icon(
                Icons.search,
                size: AppSizes.r25,
                color: AppColors.brown,
              )),
        ],
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: AppSizes.r0,
        title: Image.asset(
          'assets/images/logoshop.png',
          width: AppSizes.r90,
          height: AppSizes.r90,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: AppSizes.r16),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .where('isDiscounts', isEqualTo: true)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');

                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return Column(
                        children: [
                          CarouselSlider.builder(
                              options: CarouselOptions(
                                  height: AppSizes.r180,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 5),
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  }),
                              itemCount: docs.length,
                              itemBuilder: (BuildContext context, int i,
                                  int pageViewIndex) {
                                final data = docs[i].data();
                                return InkWell(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: ProductPage(
                                          snapshot.data!.docs[i].id),
                                      withNavBar: false,
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(AppSizes.r6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.r15),
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(data['imageurl']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: AppSizes.r5,
                                        left: AppSizes.r6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.grey,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(AppSizes.r15),
                                              bottomRight:
                                                  Radius.circular(AppSizes.r15),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.all(AppSizes.r10),
                                            child: TextWidget(
                                              text:
                                                  ' ${data['discounts']}% off',
                                              color: AppColors.brown,
                                              size: FontSizes.sp16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: AppSizes.r6,
                                        right: AppSizes.r6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.grey,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(AppSizes.r15),
                                              bottomRight:
                                                  Radius.circular(AppSizes.r15),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: AppSizes.r10,
                                              left: AppSizes.r10,
                                              top: AppSizes.r6,
                                              bottom: AppSizes.r6,
                                            ),
                                            child: TextWidget(
                                              text: '${data['title']}',
                                              color: AppColors.brown,
                                              size: FontSizes.sp16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(height: AppSizes.r8),
                          AnimatedSmoothIndicator(
                            activeIndex: activeIndex,
                            count: docs.length,
                            effect: WormEffect(
                              dotWidth: AppSizes.r6,
                              dotHeight: AppSizes.r6,
                              spacing: AppSizes.r4,
                            ),
                          ),
                        ],
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: AppSizes.r16,
                    left: AppSizes.r16,
                    top: AppSizes.r32,
                    bottom: AppSizes.r8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Categories',
                        color: AppColors.brown,
                        size: FontSizes.sp18,
                        fontWeight: FontWeight.bold,
                      ),
                      TextWidget(
                        text: 'View More',
                        color: AppColors.blue,
                        size: FontSizes.sp12,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: AppSizes.r16,
                    left: AppSizes.r16,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InKWellWidget(
                          image: 'Clothes.png',
                          page: ClothesPage(),
                        ),
                        InKWellWidget(
                          image: 'trouser.png',
                          page: TrouserPage(),
                        ),
                        InKWellWidget(
                          image: 'Shoes.png',
                          page: ShoesPage(),
                        ),
                        InKWellWidget(
                          image: 'Electronics.png',
                          page: ElectronicsPage(),
                        ),
                        InKWellWidget(
                          image: 'Furniture.png',
                          page: FurniturePage(),
                        ),
                        InKWellWidget(
                          image: 'Dresses.png',
                          page: DressesPage(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: AppSizes.r16,
                    left: AppSizes.r16,
                    top: AppSizes.r32,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Latest Products',
                        color: AppColors.brown,
                        size: FontSizes.sp18,
                        fontWeight: FontWeight.bold,
                      ),
                      TextWidget(
                        text: 'View More',
                        color: AppColors.blue,
                        size: FontSizes.sp12,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: AppSizes.r500,
                  height: AppSizes.r740,
                  child: StreamBuilderWidget(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
