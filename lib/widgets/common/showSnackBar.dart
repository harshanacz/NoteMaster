import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';

void showSnackBar(BuildContext context, String title) {
  final snackBar = SnackBar(
    content: Text(title),
    backgroundColor: drawerBackgroundcolor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
