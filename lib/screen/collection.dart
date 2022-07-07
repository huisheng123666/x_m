import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_m/components/category/category_item.dart';
import 'package:x_m/components/initLoading.dart';
import 'package:x_m/components/loadingMore.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/screen/video_play.dart';
import 'package:x_m/util.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Collection();
  }
}

class _Collection extends State<Collection> {
  List<Movie> movies = [];
  int page = 1;
  int total = 0;
  bool hasMore = false;
  final ScrollController _scrollController = ScrollController();
  bool isLoadMoreing = false;
  bool isInit = false;
  bool isErr = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _getList() {
    setState(() {
      isErr = false;
      isInit = page != 1;
    });
    Map<String, dynamic> params = {
      'pageNum': page,
      'pageSize': 18,
    };
    return Util.dio
        .get('/movie/collections', queryParameters: params)
        .then((res) {
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

  @override
  void initState() {
    super.initState();
    _getList();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '收藏',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
        ),
      ),
      body: InitLoading(
        loading: !isInit,
        isErr: isErr,
        refresh: () {
          page = 1;
          _getList();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CategoryItem(
                    movie: movies[index],
                    ontap: () {
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
      ),
    );
  }
}
