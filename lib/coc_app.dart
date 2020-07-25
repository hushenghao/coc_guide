import 'package:coc_guide/download_page.dart';
import 'package:coc_guide/home_page.dart';
import 'package:coc_guide/wiki_page.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
final RAW_URL = "https://gitee.com/dede_hu/coc-guide-resource/raw/master/";

//  final rawUrl = "https://raw.githubusercontent.com/hushenghao/coc-guide-resource/master/";

class CocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/download": (context) => DownloadPage(),
        "/wiki": (context) => WikiPage(),
      },
    );
  }
}
