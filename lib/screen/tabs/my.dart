import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/screen/login.dart';
import 'package:x_m/util.dart';

class My extends StatefulWidget {
  const My({super.key});

  @override
  State<StatefulWidget> createState() {
    return _My();
  }
}

class _My extends State<My> {
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: Util.screenWidth(context),
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/user/user_bg.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: isLogin
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://img2.baidu.com/it/u=1994380678,3283034272&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '回声',
                          style: TextStyle(
                            fontSize: 30,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            color: xPrimaryColor,
                          ),
                        )
                      ],
                    )
                  : CupertinoButton.filled(
                      child: Text('登陆'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          CupertinoPageRoute(
                            builder: (context) => Login(),
                          ),
                        )
                            .then((value) {
                          Util.setStatusBarTextColor(myStatusBarColor);
                        });
                      }),
            ),
            Container(
              width: Util.screenWidth(context),
              height: 12,
              color: const Color(0xfff6f6f6),
            ),
            const LinkItem(
              name: '收藏',
              icon: Icons.video_collection_outlined,
            ),
            const LinkItem(
              name: '求片',
              icon: Icons.video_camera_front_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class LinkItem extends StatelessWidget {
  const LinkItem({
    Key? key,
    this.onTap,
    required this.name,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xfff6f6f6),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
              color: const Color(0xffc2c2c2),
            ),
            const SizedBox(width: 10),
            Text(
              name,
              style: const TextStyle(
                height: 1.2,
                decoration: TextDecoration.none,
                fontSize: 18,
                color: Color(0xff2b2b2b),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xffc7c7c7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
