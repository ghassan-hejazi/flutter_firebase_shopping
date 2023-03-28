import 'package:flutter/material.dart';

class ImageSplashWidget extends StatelessWidget {
  const ImageSplashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/splash.png',
    );
  }
}
