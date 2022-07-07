import 'package:flutter/material.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/util.dart';

class VideoIntro extends StatefulWidget {
  final Movie movie;

  const VideoIntro({super.key, required this.movie});

  @override
  State<StatefulWidget> createState() {
    return _VideoIntro(movie);
  }
}

class _VideoIntro extends State<VideoIntro> {
  final Movie movie;
  bool isCollection = false;

  _VideoIntro(this.movie);

  _collection() {
    Util.dio.get('/movie/collection', queryParameters: {
      'id': movie.oid,
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
      'id': movie.oid,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              movie.title,
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
              '分类：${movie.category} · 语言：${movie.language} · 导演：${movie.director}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xffa5a5a5), height: 1.6),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
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
                onTap: () {},
                child: const Icon(
                  Icons.share,
                  color: Color(0xffcfcfcf),
                  size: 35,
                ),
              ),
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
              movie.intro,
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
              movie.actor,
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
}
