import 'dart:async';

import 'package:flutter/material.dart';
import 'package:x_m/components/loadingMore.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/screen/video_play.dart';

import '../../util.dart';

class Cateogry extends StatefulWidget {
  const Cateogry({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Category();
  }
}

class Cate {
  final String label;
  final String value;

  Cate({required this.label, required this.value});
}

List<Cate> cateTitle = [
  Cate(label: '电影', value: '1'),
  Cate(label: '电视剧', value: '14'),
  Cate(label: '综艺', value: '21'),
  Cate(label: '动漫', value: '26'),
];

class _Category extends State<Cateogry> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: cateTitle.length, vsync: this);
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
                (item) => Text(item.label),
              )
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children:
            cateTitle.map((cate) => CategoryPage(type: cate.value)).toList(),
      ),
    );
  }
}

class CategoryPage extends StatefulWidget {
  final String type;

  const CategoryPage({super.key, required this.type});

  @override
  State<StatefulWidget> createState() {
    return _CategoryPage();
  }
}

class _CategoryPage extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  List<Movie> movies = [];
  int page = 1;
  int total = 0;
  bool hasMore = false;
  final ScrollController _scrollController = ScrollController();
  bool isLoadMoreing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
              _scrollController.position.maxScrollExtent - 30 &&
          hasMore &&
          !isLoadMoreing) {
        isLoadMoreing = true;
        page++;
        _getList();
      }
    });
    _getList();
  }

  Future _getList() async {
    Map<String, dynamic> params = {
      'pageNum': page,
      'pageSize': 18,
      'type': widget.type
    };
    return Util.dio.get('/movie/list', queryParameters: params).then((res) {
      if (res.data['err'] == true) {
        setState(() {
          isLoadMoreing = false;
        });
        return;
      }
      Map<String, dynamic> pageData = res.data['data']['page'];
      page = pageData['pageNum'];
      total = pageData['total'];
      List<dynamic> list = res.data['data']['list'];
      List<Movie> moviesTem = [];
      for (var i = 0; i < list.length; i++) {
        moviesTem.add(Movie.formatJson(list[i]));
      }
      setState(() {
        if (page == 1) {
          movies = moviesTem;
        } else {
          movies.addAll(moviesTem);
        }
        hasMore = (total / 18).ceil() > page;
        isLoadMoreing = false;
      });
    });
  }

  Future _refresh() async {
    page = 1;
    total = 0;
    await _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: xPrimaryColor,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => CategoryItem(
                  movie: movies[index],
                  ontap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => VideoPaly(movie: movies[index]),
                      ),
                    )
                        .then((value) {
                      Timer(const Duration(milliseconds: 300), () {
                        Util.setStatusBarTextColor(tabStatusBarStyle);
                      });
                    });
                  },
                ),
                childCount: movies.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 85 / 175,
                crossAxisSpacing: 10,
              ),
            ),
            LoadingMore(hasMore: hasMore)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
    required this.movie,
    required this.ontap,
  }) : super(key: key);

  final Movie movie;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            movie.cover,
            width: double.infinity,
            height: 180,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, bottom: 2),
            child: Text(
              movie.title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              movie.showTime,
              style: const TextStyle(
                color: Color(0xffb3b3b3),
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
