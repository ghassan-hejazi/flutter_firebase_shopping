// ignore_for_file: avoid_print, prefer_const_constructors_in_immutables, sort_child_properties_last, prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, must_be_immutable, no_leading_underscores_for_local_identifiers, unused_element, unused_local_variable, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, dead_code, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:intl/intl.dart';
import 'package:shopping/UsersPages/home_Page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/positioned_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class ProductPage extends StatefulWidget {
  String docId;
  ProductPage(this.docId, {Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool show_favorite = true;
  bool _customTileExpanded = false;
  int currentCount = 1;
  String formatter = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.now());

  var sized;
  var colorOrders;
  double? ahh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.brown,
              size: AppSizes.r25,
            ),
          );
        }),
        backgroundColor: AppColors.grey,
        elevation: AppSizes.r0,
        title: TextWidget(
          text: 'Product Details',
          color: AppColors.brown,
          size: FontSizes.sp18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.docId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            double gh = double.parse(data['price']);
            double ah = gh -
                double.parse(data['price']) *
                    double.parse(data['discounts']) /
                    100;
            if (data['isDiscounts'] == true) {
              ahh = ah;
            } else {
              ahh = double.parse(data['price']);
            }
            Future addToOrders() async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              var currentUser = _auth.currentUser;
              CollectionReference users =
                  FirebaseFirestore.instance.collection("users");
              CollectionReference _collectionRef =
                  FirebaseFirestore.instance.collection("users-Orders-items");
              return _collectionRef
                  .doc(currentUser!.email)
                  .collection("items")
                  .doc(widget.docId)
                  .set({
                "title": data['title'],
                "price": ahh,
                "imageurl": data['imageurl'],
                "color": colorOrders,
                "docId": data['docId'],
                "size_user": sized,
                "countProducts": currentCount.toInt(),
                "dateOrder": formatter.toString(),
              }).then((value) => print("Added to orders"));
            }

            Future addToOrdersAll() async {
              CollectionReference _collectionRef =
                  FirebaseFirestore.instance.collection("All-Orders-items");
              return _collectionRef.doc().set({
                "title": data['title'],
                "price": ahh,
                "imageurl": data['imageurl'],
                "color": colorOrders,
                "docId": data['docId'],
                "size_user": sized,
                "countProducts": currentCount.toInt(),
                "dateOrder": formatter.toString(),
                "userOrders": GetStorage().read('username'),
                "mobilenumber": GetStorage().read('mobilenumber'),
                "country": GetStorage().read('country'),
                "city": GetStorage().read('city'),
                "streetandregion": GetStorage().read('streetandregion'),
              }).then((value) => print("Added to orders"));
            }

            return ListView(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.network(
                        data['imageurl'],
                        width: double.infinity,
                        height: AppSizes.r260,
                        fit: BoxFit.fill,
                      ),
                    ),
                    if (data['isDiscounts'] == true)
                      PositionedWidget(
                        data: '-${data['discounts']}%',
                        padding: AppSizes.r12,
                        bottomRightRadius: AppSizes.r0,
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(AppSizes.r16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            text: '${data['title']}',
                            color: AppColors.brown,
                            size: FontSizes.sp20,
                            fontWeight: FontWeight.w700,
                          ),
                          Spacer(),
                          if (data['isDiscounts'] == true)
                            Row(
                              children: [
                                TextWidget(
                                  text: '\$',
                                  color: AppColors.green,
                                  size: FontSizes.sp18,
                                  fontWeight: FontWeight.w700,
                                ),
                                TextWidgetTow(
                                  text: '${double.parse(data['price'])}',
                                ),
                                TextWidget(
                                  text: ' - ${ah}',
                                  color: AppColors.black,
                                  size: FontSizes.sp20,
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
                                  size: FontSizes.sp18,
                                  fontWeight: FontWeight.w700,
                                ),
                                TextWidget(
                                  text: '${double.parse(data['price'])}',
                                  color: AppColors.black,
                                  size: FontSizes.sp20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: AppSizes.r16),
                      ExpansionTile(
                        tilePadding: EdgeInsets.all(AppSizes.r0),
                        childrenPadding: EdgeInsets.only(left: AppSizes.r8),
                        backgroundColor: AppColors.white,
                        title: TextWidget(
                          text: 'Description',
                          color: AppColors.green,
                          size: FontSizes.sp18,
                          fontWeight: FontWeight.w600,
                        ),
                        trailing: Icon(
                          _customTileExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: AppSizes.r28,
                        ),
                        children: <Widget>[
                          TextWidget(
                            text: data['description'],
                            color: AppColors.black,
                            size: FontSizes.sp14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          setState(() => _customTileExpanded = expanded);
                        },
                      ),
                      SizedBox(height: AppSizes.r16),
                      TextWidget(
                        text: 'Size : ',
                        color: AppColors.green,
                        size: FontSizes.sp18,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomRadioButton(
                        absoluteZeroSpacing: true,
                        autoWidth: true,
                        height: AppSizes.r40,
                        unSelectedColor: Theme.of(context).canvasColor,
                        buttonLables: [
                          for (var i = 0; i < data['size'].length; i++)
                            if (data['size'][i] != '0' && data['size'][i] != '')
                              data['size'][i],
                        ],
                        buttonValues: [
                          for (var i = 0; i < data['size'].length; i++)
                            if (data['size'][i] != '0' && data['size'][i] != '')
                              data['size'][i],
                        ],
                        defaultSelected: data['size'][0],
                        buttonTextStyle: ButtonTextStyle(
                          selectedColor: AppColors.white,
                          unSelectedColor: AppColors.black,
                          textStyle: TextStyle(fontSize: FontSizes.sp14),
                        ),
                        radioButtonValue: (value) {
                          setState(() {
                            sized = value;
                          });
                          print(value);
                        },
                        selectedColor: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(height: AppSizes.r16),
                      TextWidget(
                        text: 'Colors : ',
                        color: AppColors.green,
                        size: FontSizes.sp18,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.r70,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: BlockPicker(
                            availableColors: [
                              for (var i = 0; i < data['listColor'].length; i++)
                                Color(
                                  data['listColor'][i],
                                ),
                            ],
                            pickerColor: Color(
                              data['listColor'][0],
                            ),
                            onColorChanged: (val) {
                              setState(() {
                                colorOrders = val.value;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: AppSizes.r40,
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(AppSizes.r25),
                            ),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (currentCount > 1) {
                                        currentCount--;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: AppColors.black,
                                    size: AppSizes.r25,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.white,
                                    elevation: AppSizes.r1,
                                    minimumSize:
                                        Size(AppSizes.r35, AppSizes.r35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppSizes.r25),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppSizes.r15),
                                TextWidget(
                                  text: '$currentCount',
                                  color: AppColors.black,
                                  size: FontSizes.sp20,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: AppSizes.r15),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      currentCount++;
                                    });
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.black,
                                    size: AppSizes.r25,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.white,
                                    elevation: AppSizes.r1,
                                    minimumSize:
                                        Size(AppSizes.r35, AppSizes.r35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppSizes.r25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.r15),
                      ElevatedButton(
                        onPressed: () {
                          addToOrders();
                          addToOrdersAll();
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return HomePage();
                          })));
                        },
                        child: TextWidget(
                          text: 'BUY NOW',
                          color: AppColors.brown,
                          size: FontSizes.sp20,
                          fontWeight: FontWeight.bold,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey,
                            minimumSize: Size(double.infinity, AppSizes.r50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r16),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
