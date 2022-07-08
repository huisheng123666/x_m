import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_m/components/category/category_item.dart';
import 'package:x_m/components/initLoading.dart';
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
  bool isInit = false;
  bool isErr = false;

  String activeSub = '全部';

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
    setState(() {
      isErr = false;
    });
    Map<String, dynamic> params = {
      'pageNum': page,
      'pageSize': 18,
      'type': widget.type
    };
    if (activeSub != '全部') {
      params['category'] = activeSub;
    }
    return Util.dio.get('/movie/list', queryParameters: params).then((res) {
      if (res.data['err'] == true) {
        setState(() {
          isLoadMoreing = false;
          isErr = page == 1;
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
        isInit = true;
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
    super.build(context);
    return Column(
      children: [
        CategorySub(
          widget: widget,
          activeSub: activeSub,
          change: (cateSub) {
            page = 1;
            setState(() {
              isInit = false;
              activeSub = cateSub;
            });
            _getList();
          },
        ),
        Expanded(
          child: InitLoading(
            loading: !isInit,
            isErr: isErr,
            refresh: () {
              page = 1;
              _getList();
            },
            child: Padding(
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
                              CupertinoPageRoute(
                                builder: (context) =>
                                    VideoPaly(movie: movies[index]),
                              ),
                            )
                                .then((value) {
                              Util.setStatusBarTextColor(tabStatusBarStyle);
                            });
                          },
                        ),
                        childCount: movies.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 85 / 175,
                        crossAxisSpacing: 10,
                      ),
                    ),
                    LoadingMore(hasMore: hasMore)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CategorySub extends StatelessWidget {
  const CategorySub({
    Key? key,
    required this.widget,
    this.activeSub = '全部',
    required this.change,
  }) : super(key: key);

  final CategoryPage widget;
  final String? activeSub;
  final void Function(String cateSub)? change;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categorySub[widget.type]!
            .map(
              (cate) => GestureDetector(
                onTap: () {
                  change!(cate);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  child: Text(
                    cate,
                    style: TextStyle(
                      color: activeSub == cate ? xPrimaryColor : Colors.black87,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
