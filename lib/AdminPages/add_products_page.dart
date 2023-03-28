// ignore_for_file: sized_box_for_whitespace, sort_child_properties_last, prefer_final_fields, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print, unused_local_variable, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, await_only_futures, unnecessary_string_interpolations, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, dead_code, unused_element

import 'dart:io';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/AdminPages/home_page_admin.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class AddProducts extends StatefulWidget {
  AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController discounts = TextEditingController();
  TextEditingController size_1 = TextEditingController();
  TextEditingController size_2 = TextEditingController();
  TextEditingController size_3 = TextEditingController();
  TextEditingController size_4 = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedValue;
  late File file;
  late Reference ref;
  var imageurl;
  List<int> listColor = [];
  late List<Color> test;
  bool isChecked = false;

//========================= adddata ==========================================
  adddata(context) async {
    if (_formKey.currentState!.validate()) {
      var products = FirebaseFirestore.instance.collection("products");
      for (var element in test) {
        if (!listColor.contains(element.value)) {
          listColor.add(element.value);
        }
      }

      products.add({
        "title": title.text,
        "price": price.value.text,
        "description": description.text,
        "type": selectedValue.toString(),
        "size": [
          size_1.text.isNotEmpty ? size_1.value.text : "a",
          size_2.text,
          size_3.text,
          size_4.text,
        ],
        "imageurl": imageurl.toString(),
        "listColor": listColor,
        'docId': products.doc().id,
        "isDiscounts": isChecked,
        "discounts": discounts.text.isNotEmpty ? discounts.value.text : "0",
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
                  print(test);

                  setState(() {});
                },
              ),
            ),
          );
        });
  }
//========================= addImage ==============================================

  addImage() async {
    var picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      file = File(picked.path);
      var rand = Random().nextInt(100000);
      var nameimage = "$rand" + basename(picked.path);
      ref = FirebaseStorage.instance.ref("images").child("$nameimage");
      await ref.putFile(file);
      imageurl = await ref.getDownloadURL();
      setState(() {});
    }
  }

//=========================================================================================
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
          'Add Products',
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
                      await addImage();
                    },
                    child: imageurl == null
                        ? CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey,
                              size: 90,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 90,
                            child: Image.file(
                              file,
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
                      labelText: 'Title',
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
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please Enter Categories';
                      }
                      return null;
                    },
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
                        labelText: "Categories",
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
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
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
                        print('mohammed :$test');

                        await adddata(context);
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
