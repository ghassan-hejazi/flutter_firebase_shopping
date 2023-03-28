// ignore_for_file: unused_field, unnecessary_null_comparison

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping/AdminPages/home_page_admin.dart';
import 'package:shopping/AuthLoginPages/forgot_passwor_page.dart';
import 'package:shopping/AuthLoginPages/signup_page.dart';
import 'package:shopping/UsersPages/home_Page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/elevated_button_widget.dart';
import 'package:shopping/widget/showd_loading.dart';
import 'package:shopping/widget/text_form_field_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _passwordVisible = true;
  late DateTime currentBackPressTime;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        showdLoading(context);
        UserCredential credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        if (credential != null) {
          FirebaseFirestore.instance
              .collection('users')
              .where('user_Id',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((QuerySnapshot ghh) {
            Map<String, dynamic> data =
                ghh.docs.first.data() as Map<String, dynamic>;
            setState(() {
              if (data['role'] == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const HomePageAdmin()),
                  ),
                );
              } else if (data['role'] == 'user') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => HomePage()),
                  ),
                );
              }
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop(context);
          AwesomeDialog(
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            context: context,
            title: 'Error',
            body: const Text('No user found for that email.'),
          ).show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop(context);
          AwesomeDialog(
                  animType: AnimType.topSlide,
                  context: context,
                  title: 'Error',
                  body: const Text('Wrong password provided for that user.'))
              .show();
        }
      }
    }
  }

  Future<bool> onWillPop() {
    final now = DateTime.now().difference(currentBackPressTime);
    currentBackPressTime = DateTime.now();

    if (now > const Duration(seconds: 2)) {
      Fluttertoast.showToast(msg: 'exit_warning', fontSize: 18);
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: AppSizes.r0,
          backgroundColor: AppColors.white,
          title: TextWidget(
            text: 'Sing in',
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
                  SizedBox(height: AppSizes.r40),
                  TextFormFieldWidget(
                    controller: email,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email,
                    labelText: 'Email',
                    validatorString: 'Please enter your email',
                  ),
                  SizedBox(height: AppSizes.r28),
                  TextFormFieldWidget(
                    controller: password,
                    obscureText: _passwordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    icon: Icons.lock,
                    labelText: 'Password',
                    validatorString: 'Please enter your Password',
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
                  SizedBox(height: AppSizes.r28),
                  ElevatedButtonWidget(
                    text: 'Login',
                    onPressed: () async {
                      signIn();
                    },
                  ),
                  SizedBox(height: AppSizes.r8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Forgot your password ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Reset password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'dont have an account ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Create account',
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
      ),
    );
  }
}
