import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

double mediaWidth = 0;

class ResponseErr {
  final String msg;

  ResponseErr(this.msg);
}

class Util {
  static Dio dio = Dio();

  static calc(int px, BuildContext context) {
    if (mediaWidth == 0) {
      mediaWidth = MediaQuery.of(context).size.width;
    }
    return px / 375 * mediaWidth;
  }

  static screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static setStatusBarTextColor(SystemUiOverlayStyle theme) {
    SystemChrome.setSystemUIOverlayStyle(theme);
  }

  static bottomSafeHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static initDio(BuildContext context) {
    ToastContext().init(context);

    Map headers = <String, dynamic>{
      'Content-Type': 'application/json',
    };

    Util.dio.options = BaseOptions(
      baseUrl: 'http://192.168.100.2:4000/api',
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: 'application/json', // Added contentType here
      headers: headers as Map<String, dynamic>?,
    );
    Util.dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) => handler.next(options),
      onResponse: (response, handler) {
        if (response.data['code'] == 200) {
          return handler.next(Response(
              requestOptions: response.requestOptions, data: response.data));
        } else {
          Toast.show(response.data['msg'], gravity: Toast.center);
          return handler.resolve(Response(
              requestOptions: response.requestOptions,
              data: <String, bool>{'err': true}));
        }
      },
      onError: (e, handler) {
        // print(e.requestOptions.data);
        Toast.show('网络错误，请稍后再试', gravity: Toast.center);
        return handler.resolve(Response(
            requestOptions: e.requestOptions,
            data: <String, bool>{'err': true}));
      },
    ));
  }
}
