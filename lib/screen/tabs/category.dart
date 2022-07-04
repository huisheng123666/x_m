import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';

import '../../util.dart';

class Cateogry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Category();
  }
}

const List<String> cateTitle = ['电影', '电视剧', '动漫', '综艺'];

class _Category extends State<Cateogry> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: cateTitle.length, vsync: this);
    _getList();
  }

  Future _getList() async {
    return Util.dio.get('/movie/recommend').then((res) {
      if (res.data['err'] == true) {
        return;
      }
      List<Movie> moviesTem = [];
      for (var i = 0; i < res.data['data'].length; i++) {
        moviesTem.add(Movie.formatJson(res.data['data'][i]));
      }
      setState(() {
        movies = moviesTem;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
        elevation: 0.3,
        bottom: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.black87,
          labelColor: xPrimaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: xPrimaryColor,
          labelPadding: const EdgeInsets.symmetric(vertical: 10),
          tabs: cateTitle
              .map(
                (item) => Text(item),
              )
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          movies[index].cover,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 8, bottom: 2),
                          child: Text(
                            movies[index].title,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            movies[index].showTime,
                            style: const TextStyle(
                              color: Color(0xffb3b3b3),
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    childCount: movies.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 85 / 175,
                    crossAxisSpacing: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Icon(Icons.local_dining),
                  ),
                )
              ],
            ),
          ),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
