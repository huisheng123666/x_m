import 'package:flutter/material.dart';
import 'package:x_m/constants.dart';

class InitLoading extends StatelessWidget {
  final bool loading;
  final Widget child;
  bool? isErr = false;
  VoidCallback? refresh;

  InitLoading({
    super.key,
    required this.loading,
    required this.child,
    this.isErr = false,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: isErr!
                ? GestureDetector(
                    onTap: refresh ?? () {},
                    child: const Text(
                      '加载失败, 点击重新加载',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
                  )
                : const CircularProgressIndicator(
                    color: xPrimaryColor,
                  ),
          )
        : child;
  }
}
