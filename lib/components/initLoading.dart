import 'package:flutter/material.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/util.dart';

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
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: loading
              ? Container(
                  color: Colors.white,
                  width: Util.screenWidth(context),
                  alignment: Alignment.center,
                  child: isErr!
                      ? GestureDetector(
                          onTap: refresh ?? () {},
                          child: Text(
                            '加载失败, ${refresh != null ? '点击重新加载' : ''}',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 15),
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: xPrimaryColor,
                        ),
                )
              : const SizedBox(),
        )
      ],
    );
  }
}
