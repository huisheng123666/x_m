import 'package:flutter/material.dart';
import 'package:x_m/models/commentModel.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   width: 30,
          //   height: 30,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     image: const DecorationImage(
          //       image: NetworkImage(
          //         'https://img1.baidu.com/it/u=2625325923,3446322967&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800',
          //       ),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user.userName,
                  style: const TextStyle(
                    color: Color(0xff282828),
                    fontSize: 14,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Color(0xff6a6a6a),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  comment.createTime,
                  style: const TextStyle(
                    color: Color(0xffc2c2c2),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // GestureDetector(
          //     onTap: () {},
          //     child: Column(
          //       children: const [
          //         SizedBox(height: 10),
          //         Icon(
          //           Icons.favorite,
          //           color: xPrimaryColor,
          //           size: 20,
          //         ),
          //         SizedBox(height: 4),
          //         Text(
          //           '200',
          //           style: TextStyle(color: Colors.black54, fontSize: 12),
          //         )
          //       ],
          //     )),
        ],
      ),
    );
  }
}
