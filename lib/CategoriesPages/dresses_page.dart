import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping/style/app_colors.dart';
import 'package:shopping/style/app_sizes.dart';
import 'package:shopping/widget/stream_builder_widget.dart';
import 'package:shopping/widget/text_widget.dart';

class DressesPage extends StatelessWidget {
  const DressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: AppSizes.r0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppSizes.r25,
          ),
          color: AppColors.brown,
        ),
        backgroundColor: AppColors.white,
        title: TextWidget(
          text: 'Dresses',
          color: AppColors.brown,
          size: FontSizes.sp18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: StreamBuilderWidget(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('type', isEqualTo: 'dresses')
            .snapshots(),
      ),
    );
  }
}
