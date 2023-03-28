// ignore_for_file: sized_box_for_whitespace, sort_child_properties_last, prefer_final_fields, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print, unused_local_variable, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, await_only_futures, unnecessary_string_interpolations, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, dead_code, unused_element, must_be_immutable, file_names

import 'dart:io';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/AdminPages/home_page_admin.dart';

class EditProducts extends StatefulWidget {
  String docId;
  final list;

  EditProducts(
    this.docId, {
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  late TextEditingController title;
  late TextEditingController price;
  late TextEditingController description;
  late TextEditingController type;
  late TextEditingController size_1;
  late TextEditingController size_2;
  late TextEditingController size_3;
  late TextEditingController size_4;
  TextEditingController discounts = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedValue;
  File? file;
  late Reference ref;
  var imageurl;
  List<int> listColor = [];
  Color currentColor = Color(0xff443a49);
  var products = FirebaseFirestore.instance.collection("products");
  late List<Color> test;
  bool isChecked = false;

//========================= editdata ==========================================
  editdata(context) async {
    if (file == null) {
      if (_formKey.currentState!.validate()) {}
      for (var element in test) {
        if (!listColor.contains(element.value)) {
          listColor.add(element.value);
        }
      }
      FirebaseFirestore.instance
          .collection("users-cart-items")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("items")
          .doc(widget.docId)
          .update({
            "title": title.text,
            "price": price.text,
          })
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
      products.doc(widget.docId).update({
        "title": title.text,
        "price": price.text,
        "description": description.text,
        "type": selectedValue.toString(),
        "size": [size_1.text, size_2.text, size_3.text, size_4.text],
        "listColor": listColor,
        'discounts': discounts.value.text,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => HomePageAdmin()),
        ),
      );
    } else {
      if (_formKey.currentState!.validate()) {}
      for (var element in test) {
        if (!listColor.contains(element.value)) {
          listColor.add(element.value);
        }
      }
      FirebaseFirestore.instance
          .collection("users-cart-items")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("items")
          .doc(widget.docId)
          .update({
            "title": title.text,
            "price": price.text,
            "imageurl": imageurl.toString(),
          })
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
      products.doc(widget.docId).update({
        "title": title.text,
        "price": price.text,
        "description": description.text,
        "type": description.text.toString(),
        "size": [size_1.text, size_2.text, size_3.text, size_4.text],
        "imageurl": imageurl.toString(),
        "listColor": listColor.toString(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => HomePageAdmin()),
        ),
      );
    }
  }

//========================= showColor =========================================
  showColor(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              actions: [
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: MultipleChoiceBlockPicker(
                  pickerColors: [],
                  onColorsChanged: (List<Color> colorss) {
                    test = colorss.toList();
                    setState(() {});
                  },
                ),
              ));
        });
  }
//========================= editImage ==============================================

  editImage() async {
    var picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      file = File(picked.path);
      var rand = Random().nextInt(100000);
      var nameimage = "$rand" + basename(picked.path);
      ref = FirebaseStorage.instance.ref("images").child("$nameimage");
      await ref.putFile(file!);
      imageurl = await ref.getDownloadURL();
      setState(() {});
    }
  }

//=========================================================================================

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.list['title']);
    price = TextEditingController(text: widget.list['price']);
    description = TextEditingController(text: widget.list['description']);
    size_1 = TextEditingController(text: widget.list['size'][0]);
    size_2 = TextEditingController(text: widget.list['size'][1]);
    size_3 = TextEditingController(text: widget.list['size'][2]);
    size_4 = TextEditingController(text: widget.list['size'][3]);
    discounts = TextEditingController(text: widget.list['discounts']);
  }

  @override
  void dispose() {
    title.dispose();
    price.dispose();
    description.dispose();
    size_1.dispose();
    size_2.dispose();
    size_3.dispose();
    size_4.dispose();
    discounts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF3C4657),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          'Edit Products',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3C4657),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
                padding: const EdgeInsets.only(left: 24, right: 24),
                children: [
                  const SizedBox(height: 32),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      await editImage();
                    },
                    child: imageurl == null
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 90,
                            child: Image.network(
                              widget.list['imageurl'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 90,
                            child: Image.file(
                              file!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: title,
                    cursorHeight: 30,
                    style: const TextStyle(
                      fontSize: 20,
                      decorationThickness: 0,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    cursorHeight: 30,
                    style: const TextStyle(
                      fontSize: 20,
                      decorationThickness: 0,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Price';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                      contentPadding:
                          EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: description,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    minLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      decorationThickness: 0,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                      labelText: 'description',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                      contentPadding:
                          EdgeInsets.only(left: 0, top: 10, bottom: 10),
                    ),
                  ),
                  const SizedBox(height: 32),
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                    ),
                    items: [
                      "clothes",
                      "electronics",
                      "furniture",
                      "shoes",
                      "trouser",
                      "dresses"
                    ],
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      baseStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: widget.list['type'],
                        contentPadding:
                            EdgeInsets.only(left: 0, top: 10, bottom: 10),
                        prefixIcon: Icon(Icons.view_list),
                      ),
                    ),
                    onChanged: (val) {
                      selectedValue = val;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Size :',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: size_1,
                          keyboardType: TextInputType.text,
                          cursorHeight: 30,
                          style: const TextStyle(
                            fontSize: 20,
                            decorationThickness: 0,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: size_2,
                          keyboardType: TextInputType.text,
                          cursorHeight: 30,
                          style: const TextStyle(
                            fontSize: 20,
                            decorationThickness: 0,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: size_3,
                          keyboardType: TextInputType.text,
                          cursorHeight: 30,
                          style: const TextStyle(
                            fontSize: 20,
                            decorationThickness: 0,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: size_4,
                          keyboardType: TextInputType.text,
                          cursorHeight: 30,
                          style: const TextStyle(
                            fontSize: 20,
                            decorationThickness: 0,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Text(
                        'Discounts : ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3C4657),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: discounts,
                          keyboardType: TextInputType.number,
                          cursorHeight: 30,
                          style: const TextStyle(
                            fontSize: 20,
                            decorationThickness: 0,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                      onPressed: () {
                        showColor(context);
                      },
                      child: Text(
                        'color',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3C4657),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: const Color(0xFFFD6969),
                      )),
                  const SizedBox(height: 32),
                  ElevatedButton(
                      onPressed: () async {
                        await editdata(context);
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3C4657),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: const Color(0xFFFD6969),
                      )),
                  const SizedBox(height: 32),
                ]),
          ),
        ),
      ),
    );
  }
}
