// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    Key? key,
    required this.controller,
    required this.icon,
    required this.labelText,
    required this.validatorString,
    required this.keyboardType,
    this.suffixIcon,
    required this.obscureText,
  }) : super(key: key);
  final TextEditingController controller;
  IconData icon;
  String labelText;
  String validatorString;
  TextInputType keyboardType;
  Widget? suffixIcon;
  bool obscureText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.r60,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.r15,
              right: AppSizes.r15,
            ),
            child: Icon(
              icon,
              size: AppSizes.r22,
            ),
          ),
          VerticalDivider(
            width: AppSizes.r0,
            color: AppColors.grey700,
            endIndent: AppSizes.r10,
            indent: AppSizes.r10,
            thickness: AppSizes.r1,
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              cursorHeight: AppSizes.r22,
              style: TextStyle(
                fontSize: FontSizes.sp16,
                decorationThickness: AppSizes.r0,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return validatorString;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  color: AppColors.grey700,
                  fontSize: FontSizes.sp16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: AppSizes.r12,
                  top: AppSizes.r5,
                  bottom: AppSizes.r5,
                ),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
