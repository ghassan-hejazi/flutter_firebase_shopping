// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopping/AuthLoginPages/signin_page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/elevated_button_widget.dart';
import 'package:shopping/widget/showd_loading.dart';
import 'package:shopping/widget/text_form_field_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobilenumber = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController streetandregion = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  adddata() {
    FirebaseFirestore.instance.collection("users").add({
      "username": name.text,
      "email": email.text,
      "password": password.text,
      "mobilenumber": mobilenumber.text,
      "country": country.text,
      "city": city.text,
      "streetandregion": streetandregion.text,
      "user_Id": FirebaseAuth.instance.currentUser!.uid,
      "role": "user",
    });

    GetStorage().write('username', name.text);
    GetStorage().write('mobilenumber', mobilenumber.text);
    GetStorage().write('country', country.text);
    GetStorage().write('city', city.text);
    GetStorage().write('streetandregion', streetandregion.text);
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {}
    try {
      showdLoading(context);
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.of(context).pop(context);
        AwesomeDialog(
          context: context,
          title: 'Error',
          body: const Text('The password provided is too weak.'),
        ).show();
      } else if (e.code == 'email-already-in-use') {
        Navigator.of(context).pop(context);
        AwesomeDialog(
          context: context,
          title: 'Error',
          body: const Text('The account already exists for that email.'),
        ).show();
      }
    } catch (e) {
      print(e);
    }
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
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: AppSizes.r0,
        title: TextWidget(
          text: 'Create account',
          color: AppColors.brown,
          size: FontSizes.sp20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.only(
                left: AppSizes.r10,
                right: AppSizes.r10,
              ),
              children: [
                SizedBox(height: AppSizes.r28),
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
                  controller: email,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                  labelText: 'Email',
                  validatorString: 'Please enter your email',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: password,
                  obscureText: _passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  icon: Icons.lock,
                  labelText: 'Password',
                  validatorString: 'Please enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: mobilenumber,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone,
                  labelText: 'Mobile Number',
                  validatorString: 'Please enter your Mobile Number',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: country,
                  obscureText: false,
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.location_on,
                  labelText: 'Country',
                  validatorString: 'Please enter your Country',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: city,
                  obscureText: false,
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.location_on,
                  labelText: 'City',
                  validatorString: 'Please enter your city',
                ),
                SizedBox(height: AppSizes.r8),
                TextFormFieldWidget(
                  controller: streetandregion,
                  obscureText: false,
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.location_on,
                  labelText: 'Street Or Region',
                  validatorString: 'Please enter your Street Or Region',
                ),
                SizedBox(height: AppSizes.r8),
                ElevatedButtonWidget(
                  text: 'Create',
                  onPressed: () async {
                    var response = await signUp();
                    if (response != null) {
                      await adddata();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const SignInPage()),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: AppSizes.r12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'do you have an account ?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInPage()));
                      },
                      child: const Text(
                        'Sing in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
