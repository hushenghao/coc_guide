import 'package:coc_guide/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:toast/toast.dart';

class WikiPage extends StatefulWidget {
  final String path;

  WikiPage({Key key, this.path = "README.md"}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WikiState();
}

class _WikiState extends State<WikiPage> {
  String _markdownData = "";
  final controller = ScrollController();

  bool landscape = false;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  @override
  void dispose() {
//    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Wiki"),
//        trailing: Icon(
//          CupertinoIcons.circle,
//        ),
      ),
      child: SafeArea(
        child: Markdown(
          controller: controller,
          selectable: false,
          data: _markdownData,
          onTapLink: (href) {
            if (href.endsWith(".md")) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => WikiPage(
                            path: href,
                          )));
              return;
            }
            openBrower(context, href);
          },
          imageDirectory: rawUrl,
        ),
      ),
    );
  }

  final rawUrl = "https://gitee.com/dede_hu/coc-guide-resource/raw/master/";

//  final rawUrl = "https://raw.githubusercontent.com/hushenghao/coc-guide-resource/master/";

  void _loadMarkdown() async {
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    try {
      Response response = await dio.get(rawUrl + widget.path);
      setState(() {
        _markdownData = response.data.toString();
      });
    } catch (e) {
      Toast.show("网络加载失败", context);
      print(e);
    }
  }
}
