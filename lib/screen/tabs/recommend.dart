import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_m/components/initLoading.dart';
import 'package:x_m/components/recommend/recommend_item.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/screen/search.dart';
import 'package:x_m/screen/video_play.dart';
import 'package:x_m/util.dart';

class Recommend extends StatefulWidget {
  const Recommend({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Recommend();
  }
}

class _Recommend extends State<Recommend> {
  List<Movie> movies = [];
  bool isInit = false;
  bool initErr = false;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  Future _onRefrsh() async {
    await _getList();
  }

  Future _getList() async {
    setState(() {
      initErr = false;
    });
    return Util.dio.get('/movie/recommend').then((res) {
      if (res.data['err'] == true) {
        setState(() {
          initErr = true;
        });
        return;
      }
      List<Movie> moviesTem = [];
      for (var i = 0; i < res.data['data'].length; i++) {
        moviesTem.add(Movie.formatJson(res.data['data'][i]));
      }
      setState(() {
        movies = moviesTem;
        isInit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        title: const Text(
          'HOT',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.2,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                CupertinoPageRoute(
                  builder: (context) => Search(),
                ),
              )
                  .then((value) {
                Util.setStatusBarTextColor(tabStatusBarStyle);
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.search,
                color: Color(0xff010101),
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: InitLoading(
        loading: !isInit,
        isErr: initErr,
        refresh: _getList,
        child: RefreshIndicator(
          onRefresh: _onRefrsh,
          color: xPrimaryColor,
          child: ListView.builder(
            itemBuilder: (context, index) => RecommendItem(
              movie: movies[index],
              onTab: () {
                Navigator.of(context)
                    .push(
                  CupertinoPageRoute(
                    builder: (context) => VideoPaly(movie: movies[index]),
                  ),
                )
                    .then((value) {
                  Util.setStatusBarTextColor(tabStatusBarStyle);
                });
              },
            ),
            itemCount: movies.length,
          ),
        ),
      ),
    );
  }
}
