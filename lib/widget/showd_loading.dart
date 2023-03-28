import 'package:flutter/material.dart';

showdLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Please Wiat'),
          content: SizedBox(
            height: 60,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}

showdmessage(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Please Wiat'),
          content: SizedBox(
            height: 60,
            child: Center(
              child: Text('Send a password reset link to your email'),
            ),
          ),
        );
      });
}
