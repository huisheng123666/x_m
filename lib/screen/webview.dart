import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:x_m/components/initLoading.dart';
import 'package:x_m/constants.dart';
import 'package:x_m/util.dart';

class Webview extends StatefulWidget {
  const Webview({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  bool loading = true;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    Util.setStatusBarTextColor(tabStatusBarStyle);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black87),
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
      body: SizedBox(
        width: Util.screenWidth(context),
        height: double.infinity,
        child: InitLoading(
          loading: loading,
          isErr: isError,
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onPageFinished: (url) {
              setState(() {
                loading = false;
              });
            },
            onProgress: (progress) {
              if (progress >= 80) {
                setState(() {
                  loading = false;
                });
              }
            },
            onWebResourceError: (error) {
              setState(() {
                isError = true;
              });
            },
          ),
        ),
      ),
    );
  }
}
