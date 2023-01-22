import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {Key? key,
      required this.size,
      required this.text,
      this.textColor = whiteColor,
      this.align = TextAlign.left,
      this.fontWeight = FontWeight.w400})
      : super(key: key);

  final double size;
  final String text;
  final Color textColor;
  final FontWeight fontWeight;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: "Montserrat",
        color: textColor,
        fontSize: size,
        fontWeight: fontWeight,
      ),
      textAlign: align,
    );
  }
}
