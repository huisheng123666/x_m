import 'package:flutter/cupertino.dart';
import 'package:x_m/constants.dart';

class LoadingMore extends StatelessWidget {
  const LoadingMore({
    Key? key,
    required this.hasMore,
  }) : super(key: key);

  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: hasMore
          ? Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CupertinoActivityIndicator(color: xPrimaryColor, radius: 8),
                  SizedBox(width: 10),
                  Text(
                    '加载中... ',
                    style: TextStyle(color: xPrimaryColor),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
