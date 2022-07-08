import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/screen/webview.dart';
import 'package:x_m/util.dart';

class VideoIntro extends StatefulWidget {
  final Movie movie;
  final VoidCallback? clickComment;

  const VideoIntro({super.key, required this.movie, this.clickComment});

  @override
  State<StatefulWidget> createState() {
    return _VideoIntro();
  }
}

class _VideoIntro extends State<VideoIntro> with AutomaticKeepAliveClientMixin {
  bool isCollection = false;

  _collection() {
    Util.dio.get('/movie/collection', queryParameters: {
      'id': widget.movie.oid,
      'like': isCollection ? '0' : '1'
    }).then((res) {
      if (res.data['err'] == true) {
        return;
      }
      setState(() {
        isCollection = !isCollection;
      });
    });
  }

  _getCollectionState() {
    Util.dio.get('/movie/isCollection', queryParameters: {
      'id': widget.movie.oid,
      'noMsg': true,
    }).then((res) {
      if (res.data['err'] == true) {
        return;
      }
      setState(() {
        isCollection = res.data['data']['like'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCollectionState();
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      'X M http://admin.xmw.monster',
      subject: 'X M电影APP',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.movie.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                height: 1.4,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '分类：${widget.movie.category} · 语言：${widget.movie.language} · 导演：${widget.movie.director}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xffa5a5a5), height: 1.6),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: widget.clickComment,
                child: const Icon(
                  Icons.message,
                  color: Color(0xffcfcfcf),
                  size: 35,
                ),
              ),
              const SizedBox(width: 50),
              GestureDetector(
                onTap: _collection,
                child: Icon(
                  Icons.favorite,
                  color: isCollection ? xPrimaryColor : const Color(0xffcfcfcf),
                  size: 35,
                ),
              ),
              const SizedBox(width: 50),
              GestureDetector(
                onTap: () {
                  _onShare(context);
                },
                child: const Icon(
                  Icons.share,
                  color: Color(0xffcfcfcf),
                  size: 35,
                ),
              ),
              const SizedBox(width: 50),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    CupertinoPageRoute(
                      builder: (context) => Webview(
                          title: widget.movie.title,
                          url:
                              'https://m.douban.com/search/?query=${Uri.encodeComponent(widget.movie.title)}'),
                    ),
                  )
                      .then((value) {
                    Util.setStatusBarTextColor(videoPlayStatusBarColor);
                  });
                },
                child: const Text(
                  '豆',
                  style: TextStyle(
                    color: Color(0xffcfcfcf),
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            height: 10,
            color: const Color(0xfff6f6f6),
          ),
          const Text(
            'INTRODUCE',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.movie.intro,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.8,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'ACTOR',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.movie.actor,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: Util.bottomSafeHeight(context) + 10),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
