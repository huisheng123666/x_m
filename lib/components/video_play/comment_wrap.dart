import 'package:flutter/material.dart';
import 'package:x_m/components/video_play/comment.dart';
import 'package:x_m/util.dart';

class CommentWrap extends StatelessWidget {
  const CommentWrap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
            bottom: Util.bottomSafeHeight(context) + 60,
          ),
          itemBuilder: (context, index) => const Comment(),
          itemCount: 10,
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            alignment: Alignment.topCenter,
            height: Util.bottomSafeHeight(context) + 60,
            width: Util.screenWidth(context),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                ),
              ),
            ),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  borderRadius: BorderRadius.circular(5)),
              child: const TextField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: '请输入评论',
                    hintStyle: TextStyle(color: Color(0xff999999))),
              ),
            ),
          ),
        )
      ],
    );
  }
}
