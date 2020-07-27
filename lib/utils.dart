import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

void openBrower(BuildContext context, String href) {
  _openBrower(href).catchError((e) {
    Toast.show("不能打开当前地址", context);
    print(e);
  });
}

Future<void> _openBrower(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Color randomColor(double opacity) {
  Random random = Random.secure();
  return Color.fromRGBO(
      random.nextInt(256), random.nextInt(256), random.nextInt(256), opacity);
}

Dio defaultDio() {
  var dio = Dio();
//  dio.interceptors.add(LogInterceptor(responseBody: true));
  return dio;
}

bool isLandscape(BuildContext context) {
  var orientation = MediaQuery.of(context).orientation;
  return orientation == Orientation.landscape;
}
