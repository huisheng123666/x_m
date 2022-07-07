import 'package:flutter/material.dart';
import 'package:x_m/constants.dart';

class Button extends StatelessWidget {
  const Button(
    this.text, {
    Key? key,
    this.onTap,
    this.backgroundColor = xPrimaryColor,
    this.textColor = Colors.white,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
