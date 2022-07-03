import 'package:flutter/material.dart';
import 'package:x_m/constants.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://img1.baidu.com/it/u=2625325923,3446322967&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '回声',
                  style: TextStyle(
                    color: Color(0xff282828),
                    fontSize: 14,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '请问你的配图都是怎么找的呀有没有相关网站推荐一下',
                  style: TextStyle(
                    color: Color(0xff6a6a6a),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '2022-06-29',
                  style: TextStyle(
                    color: Color(0xffc2c2c2),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
              onTap: () {},
              child: Column(
                children: const [
                  SizedBox(height: 10),
                  Icon(
                    Icons.favorite,
                    color: xPrimaryColor,
                    size: 20,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '200',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
