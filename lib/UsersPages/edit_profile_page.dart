// ignore_for_file: sized_box_for_whitespace, sort_child_properties_last, prefer_final_fields, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print, unused_local_variable, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables, must_be_immutable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping/UsersPages/profile_page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/elevated_button_widget.dart';
import 'package:shopping/widget/text_form_field_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class EditProfilePage extends StatefulWidget {
  String user_Id;
  final list;
  EditProfilePage(
    this.user_Id, {
    Key? key,
    this.list,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController name = TextEditingController();
  TextEditingController mobilenumber = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController streetandregion = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var users = FirebaseFirestore.instance.collection("users");
  editProfileData() {
    users.doc(widget.user_Id).update({
      "username": name.text,
      "mobilenumber": mobilenumber.text,
      "country": country.text,
      "city": city.text,
      "streetandregion": streetandregion.text,
    });
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.list['username']);
    mobilenumber = TextEditingController(text: widget.list['mobilenumber']);
    country = TextEditingController(text: widget.list['country']);
    city = TextEditingController(text: widget.list['city']);
    streetandregion =
        TextEditingController(text: widget.list['streetandregion']);
  }

  @override
  void dispose() {
    name.dispose();
    mobilenumber.dispose();
    country.dispose();
    city.dispose();
    streetandregion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.brown,
            size: AppSizes.r25,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: AppSizes.r3,
        title: TextWidget(
          text: 'Edit Profile',
          color: AppColors.brown,
          size: FontSizes.sp18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.only(
                left: AppSizes.r16,
                right: AppSizes.r16,
              ),
              children: [
                SizedBox(height: AppSizes.r32),
                TextFormFieldWidget(
                  controller: name,
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  icon: Icons.person,
                  labelText: 'Full Name',
                  validatorString: 'Please enter your full name',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: mobilenumber,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone,
                  labelText: 'Mobile Number',
                  validatorString: 'Please enter a mobile phone number',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: country,
                  obscureText: false,
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.location_on,
                  labelText: 'Country',
                  validatorString: 'Please enter the country',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: city,
                  obscureText: false,
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.location_on,
                  labelText: 'City',
                  validatorString: 'Please enter the city',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: streetandregion,
                  obscureText: false,
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.location_on,
                  labelText: 'Street Or Region',
                  validatorString: 'Please enter the street and district',
                ),
                SizedBox(height: AppSizes.r32),
                ElevatedButtonWidget(
                  text: 'Save Edit',
                  onPressed: () async {
                    await editProfileData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ProfilePage()),
                      ),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
