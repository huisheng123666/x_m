import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    this.onChanged,
    this.hintText = '',
    this.label,
    this.keyboardType = TextInputType.none,
    this.controller,
    this.onSubmitted,
    this.obscureText = false,
  }) : super(key: key);

  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final String? hintText;
  final String? label;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        label != null
            ? Text(
                label!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                ),
              )
            : const SizedBox(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xffe6e6e6),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              keyboardType: keyboardType,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.black,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16),
              obscureText: obscureText!,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xff999999),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
