// ignore_for_file: prefer_const_constructors_in_immutables, sized_box_for_whitespace, non_constant_identifier_names, prefer_const_constructors, unnecessary_string_interpolations, avoid_print, use_build_context_synchronously, unused_local_variable, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping/AdminPages/detail_order_page.dart';

class OrdersAdminPage extends StatefulWidget {
  OrdersAdminPage({Key? key}) : super(key: key);

  @override
  State<OrdersAdminPage> createState() => _OrdersAdminPageState();
}

class _OrdersAdminPageState extends State<OrdersAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("All-Orders-items")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              debugPrint('mohammed : ${docs}');

              return ListView.separated(
                padding: EdgeInsets.all(10),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 2,
                    height: 30,
                  );
                },
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final data = docs[i].data();

                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return DetailOrderPage(
                          snapshot.data!.docs[i].id,
                          list: data,
                        );
                      })));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.network(
                            '${data['imageurl']}',
                            fit: BoxFit.fill,
                            width: 180,
                            height: 180,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: 150,
                          height: 180,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${data['title']}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D2E49),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${data['price'] * data['countProducts']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'number : ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 174, 113, 8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'x${data['countProducts']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Color : ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 174, 113, 8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Color(data['color']),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Size : ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 174, 113, 8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${data['size_user']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                title: Text(
                                  'DateOrder : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 174, 113, 8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${data['dateOrder']}',
                                ),
                              ),
                            ],
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
  /*
  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 15,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Column(
                            children: [
                              Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              width: double.infinity,
                              height: 170,
                              child: Image.network(
                                '${data['imageurl']}',
                                fit: BoxFit.fill,
                              ),
                            ),
                                                        Divider(height: 5, thickness: 0,color: Colors.white,),

                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, left: 8, bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${data['title']}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.cairo(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF2D2E49),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '\$',
                                          style: GoogleFonts.cairo(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${data['price']}',
                                            style: GoogleFonts.cairo(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: snapshot.data.docs.length == 0
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
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
                                  color: Color(0xFF2D2E49),
                                  size: 28,
                                )),
                          ),
                        ],
                      ),
                    ),
  */ 