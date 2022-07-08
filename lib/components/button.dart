import 'package:flutter/cupertino.dart';
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
    this.loading = false,
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? margin;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: loading! ? 0.8 : 1,
        child: Container(
          alignment: Alignment.center,
          margin: margin,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loading!
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CupertinoActivityIndicator(
                        radius: 10,
                        color: textColor,
                      ),
                    )
                  : const SizedBox(),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
