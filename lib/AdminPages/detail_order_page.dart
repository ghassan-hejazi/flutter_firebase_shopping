// ignore_for_file: avoid_print, prefer_const_constructors_in_immutables, sort_child_properties_last, prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, must_be_immutable, no_leading_underscores_for_local_identifiers, unused_element, unused_local_variable, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, dead_code

import 'package:flutter/material.dart';

class DetailOrderPage extends StatefulWidget {
  String docId;
  final list;
  DetailOrderPage(
    this.docId, {
    Key? key,
    this.list,
  }) : super(key: key);

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF2D2E49),
                size: 28,
              ),
            );
          }),
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            'Order Details',
            style: TextStyle (
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D2E49),
            ),
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: Image.network(
                widget.list['imageurl'],
                width: double.infinity,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(0),
                    title: Expanded(
                      child: Text(
                        widget.list['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    trailing: Text(
                      '\$${widget.list['price'] * widget.list['countProducts']}',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 174, 113, 8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'number of orders : ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 174, 113, 8),
                        ),
                      ),
                      Text(
                        'x${widget.list['countProducts']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Size : ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 174, 113, 8),
                        ),
                      ),
                      Text(
                        widget.list['size_user'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Colors : ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 174, 113, 8),
                        ),
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(widget.list['color']),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'DateOrder : ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 174, 113, 8),
                        ),
                      ),
                       Text(
                        widget.list['dateOrder'],
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.black,height: 0,thickness: 1),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 30,
                          ),
                          Text(
                            'country : ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 174, 113, 8),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          widget.list['country'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 30,
                          ),
                          Text(
                            'city : ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 174, 113, 8),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          widget.list['city'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 30,
                          ),
                          Text(
                            'streetandregion : ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 174, 113, 8),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          widget.list['streetandregion'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: ((context) {
                  //       return HomePage();
                  //     })));
                  //   },
                  //   child: Text(
                  //     'BUY NOW',
                  //     style: GoogleFonts.cairo(
                  //       fontSize: 22,
                  //       fontWeight: FontWeight.bold,
                  //       color: const Color(0xFF2D2E49),
                  //     ),
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFFFD6969),
                  //       minimumSize: Size(double.infinity, 60),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20),
                  //       )),
                  // ),
                ],
              ),
            ),
          ],
        )

        //return Text("Document does not exist");

        );
  }
}
