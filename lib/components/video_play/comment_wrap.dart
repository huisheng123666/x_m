import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:x_m/components/initLoading.dart';
import 'package:x_m/components/video_play/comment.dart';
import 'package:x_m/models/commentModel.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/models/page_basic.dart';
import 'package:x_m/util.dart';

class CommentWrap extends StatefulWidget {
  final Movie movie;

  const CommentWrap({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<CommentWrap> createState() => _CommentWrapState();
}

class _CommentWrapState extends State<CommentWrap>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  List<CommentModel> comments = [];
  final ScrollController _scrollController = ScrollController();

  final pageBasic = PageBasic();

  _addComment(String val) {
    if (val == '') {
      Toast.show('请输入内容');
      return;
    }
    Util.dio.post('/movie/comment', data: {
      'id': widget.movie.oid,
      'text': val,
    }).then((res) {
      if (res.data['err'] == true) {
        return;
      }
      _textEditingController.text = '';
      pageBasic.page = 1;
      _getList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  _getList() {
    setState(() {
      pageBasic.isErr = false;
    });
    Map<String, dynamic> params = {
      'pageNum': pageBasic.page,
      'pageSize': 10,
      'id': widget.movie.oid
    };
    Util.dio.get('/movie/comments', queryParameters: params).then((res) {
      if (res.data['err'] == true) {
        setState(() {
          pageBasic.isLoadMoreing = false;
          pageBasic.isErr = pageBasic.page == 1;
        });
        return;
      }
      Map<String, dynamic> pageData = res.data['data']['page'];
      pageBasic.page = pageData['pageNum'];
      pageBasic.total = pageData['total'];
      List<dynamic> list = res.data['data']['list'];
      List<CommentModel> commentsTem = [];
      for (var i = 0; i < list.length; i++) {
        commentsTem.add(CommentModel.formatJson(list[i]));
      }
      setState(() {
        if (pageBasic.page == 1) {
          comments = commentsTem;
        } else {
          comments.addAll(commentsTem);
        }
        pageBasic.hasMore = (pageBasic.total! / 18).ceil() > pageBasic.page!;
        pageBasic.isLoadMoreing = false;
        pageBasic.isInit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        InitLoading(
          loading: !pageBasic.isInit!,
          isErr: pageBasic.isErr,
          refresh: () {
            pageBasic.page = 1;
            _getList();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Comment(
                    comment: comments[index],
                  ),
                  childCount: comments.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: Util.bottomSafeHeight(context) + 70),
              )
            ],
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            alignment: Alignment.topCenter,
            height: Util.bottomSafeHeight(context) + 60,
            width: Util.screenWidth(context),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                ),
              ),
            ),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                onSubmitted: _addComment,
                controller: _textEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: '请输入评论',
                  hintStyle: TextStyle(
                    color: Color(0xff999999),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
