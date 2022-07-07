import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_m/components/category/category_item.dart';
import 'package:x_m/components/initLoading.dart';
import 'package:x_m/components/loadingMore.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/screen/video_play.dart';
import 'package:x_m/util.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Search();
  }
}

class _Search extends State<Search> {
  List<Movie> movies = [];
  int page = 1;
  int total = 0;
  bool hasMore = false;
  final ScrollController _scrollController = ScrollController();
  bool isLoadMoreing = false;
  bool isInit = true;
  bool isErr = false;

  String searchKey = '';

  _searchList(String name) {
    setState(() {
      isErr = false;
      isInit = page != 1;
      searchKey = name;
    });
    Map<String, dynamic> params = {
      'pageNum': page,
      'pageSize': 18,
      'name': name
    };
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
        _searchList(searchKey);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SizedBox(
        width: Util.screenWidth(context),
        height: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 40,
                    width: Util.screenWidth(context),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: xPrimaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      cursorColor: Colors.black,
                      style: const TextStyle(fontSize: 18),
                      onSubmitted: (String value) {
                        page = 1;
                        _searchList(value);
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '请输入关键字',
                        hintStyle: TextStyle(
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '取消',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: const Color(0xffF2F2F2),
            ),
            Expanded(
              child: InitLoading(
                loading: !isInit,
                isErr: isErr,
                refresh: () {
                  page = 1;
                  _searchList(searchKey);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
            )
          ],
        ),
      ),
    );
  }
}
