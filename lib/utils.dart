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
