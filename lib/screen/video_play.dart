import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:x_m/components/video_play/comment_wrap.dart';
import 'package:x_m/components/video_play/video_intro.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/util.dart';

class VideoPaly extends StatefulWidget {
  final Movie movie;
  const VideoPaly({super.key, required this.movie});

  @override
  State<StatefulWidget> createState() {
    return _VideoPlay();
  }
}

class _VideoPlay extends State<VideoPaly> with TickerProviderStateMixin {
  late FlickManager flickManager;
  late FlickShowControlsAction flickShowControlsAction;
  late TabController tabController;
  bool showSep = false;
  String currenturl = '';

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    Util.setStatusBarTextColor(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
        0);

    flickManager = FlickManager(
      // autoPlay: false,
      videoPlayerController: VideoPlayerController.network(
        widget.movie.playUrls[0],
        formatHint: VideoFormat.hls,
      ),
    );

    setState(() {
      currenturl = widget.movie.playUrls[0];
    });
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.ease);

    animation = Tween(begin: 60.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    flickManager.dispose();
    animationController.dispose();
    super.dispose();
  }

  void _switchPlay(String url) {
    flickManager.handleChangeVideo(VideoPlayerController.network(
      url,
      formatHint: VideoFormat.hls,
    ));
    setState(() {
      currenturl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 1),
                  height: Util.screenWidth(context) * 9 / 16,
                  color: Colors.black87,
                  child: FlickVideoPlayer(
                    flickManager: flickManager,
                    wakelockEnabledFullscreen: true,
                    preferredDeviceOrientationFullscreen: const [
                      DeviceOrientation.landscapeRight,
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: Util.screenWidth(context),
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 1],
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.12),
                          Color.fromRGBO(0, 0, 0, 0)
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        widget.movie.playUrls.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showSep = true;
                                    animationController.forward();
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: xPrimaryColor)),
                                  child: const Text(
                                    '选集',
                                    style: TextStyle(
                                        color: xPrimaryColor, fontSize: 12),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: Transform.translate(
                      offset: Offset(animation.value, 0),
                      child: Episode(
                        playUrls: widget.movie.playUrls,
                        switchPlay: _switchPlay,
                        currenUrl: currenturl,
                        close: () {
                          setState(() {
                            showSep = false;
                            animationController.reverse();
                          });
                        },
                      ),
                    )),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    height: 2,
                    width: Util.screenWidth(context),
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Container(
              height: 40,
              decoration: const BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1), width: 1),
                ),
              ),
              child: TabBar(
                controller: tabController,
                unselectedLabelColor: Colors.black87,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: xPrimaryColor,
                indicatorColor: xPrimaryColor,
                tabs: const [
                  Text('简介'),
                  Text('评论'),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: [VideoIntro(movie: widget.movie), CommentWrap()],
            ))
          ],
        ),
      ),
    );
  }
}

class Episode extends StatelessWidget {
  final List<String> playUrls;
  final void Function(String url) switchPlay;
  final VoidCallback close;
  final String currenUrl;

  const Episode({
    super.key,
    required this.playUrls,
    required this.switchPlay,
    required this.close,
    required this.currenUrl,
  });

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Container(
      height: Util.screenWidth(context) * 9 / 16 - 4,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(width: 1, color: Colors.white30),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: playUrls.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  switchPlay(playUrls[index]);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '第${index + 1}集',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: currenUrl == playUrls[index]
                          ? xPrimaryColor
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: close,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// class VideoPaly extends StatefulWidget {
//   const VideoPaly({super.key});

//   @override
//   _VideoPaly createState() => _VideoPaly();
// }

// class _VideoPaly extends State<VideoPaly> with SingleTickerProviderStateMixin {
//   late Animation<double> animation;
//   late AnimationController controller;

//   initState() {
//     super.initState();
//     controller = new AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     animation = new Tween(begin: 0.0, end: 300.0).animate(controller)
//       ..addListener(() {
//         setState(() {
//           // the state that has changed here is the animation object’s value
//         });
//       });
//     controller.forward();
//   }

//   Widget build(BuildContext context) {
//     return new Center(
//       child: new Container(
//         margin: new EdgeInsets.symmetric(vertical: 10.0),
//         height: animation.value,
//         width: animation.value,
//         child: new FlutterLogo(),
//       ),
//     );
//   }

//   dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
