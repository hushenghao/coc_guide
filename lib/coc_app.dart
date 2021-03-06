import 'package:coc_guide/download_page.dart';
import 'package:coc_guide/home_page.dart';
import 'package:coc_guide/wiki_group_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final githubUrl = "https://github.com/hushenghao/coc-guide-resource";
final rawUrl = "https://gitee.com/dede_hu/coc-guide-resource/raw/master";

//  final rawUrl = "https://raw.githubusercontent.com/hushenghao/coc-guide-resource/master";

class CocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.blue,
      ),
      showSemanticsDebugger: false,
      showPerformanceOverlay: false,
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/download": (context) => DownloadPage(),
        "/wiki": (context) => WikiGroupPage(),
      },
    );
  }
}
