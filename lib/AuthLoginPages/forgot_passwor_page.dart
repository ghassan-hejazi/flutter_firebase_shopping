// ignore_for_file: must_be_immutable, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping/AuthLoginPages/signin_page.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/elevated_button_widget.dart';
import 'package:shopping/widget/text_form_field_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  TextEditingController email = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  forgotPassword() {
    FirebaseAuth.instance
        .sendPasswordResetEmail(
          email: email.text,
        )
        .then((value) => print('sent code '))
        .catchError((onError) => print('onError : $onError'));
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
        elevation: AppSizes.r0,
        backgroundColor: AppColors.white,
        title: TextWidget(
          text: 'Forgot Password',
          color: AppColors.brown,
          size: FontSizes.sp20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
            padding: EdgeInsets.only(
              left: AppSizes.r10,
              right: AppSizes.r10,
            ),
            children: [
              SizedBox(height: AppSizes.r60),
              TextWidget(
                text: 'Send a password reset link to your email.',
                color: AppColors.brown,
                size: FontSizes.sp16,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: AppSizes.r50),
              TextFormFieldWidget(
                controller: email,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
                labelText: 'Email',
                validatorString: 'Please enter your email',
              ),
              SizedBox(height: AppSizes.r28),
              ElevatedButtonWidget(
                text: 'Reset Password',
                onPressed: () async {
                  forgotPassword();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInPage(),
                    ),
                  );
                },
              ),
              SizedBox(height: AppSizes.r12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SignIn again ?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
