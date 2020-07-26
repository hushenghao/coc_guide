import 'package:coc_guide/coc_app.dart';
import 'package:coc_guide/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:toast/toast.dart';

class MarkdownPage extends StatefulWidget {
  final String path;
  final String title;

  MarkdownPage({Key key, this.path = "/wiki/Index.md", this.title = "Wiki"})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarkdownState();
}

class _MarkdownState extends State<MarkdownPage> {
  String _markdownData = "";
  final controller = ScrollController();

  bool landscape = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    _loadMarkdown();
  }

  @override
  void deactivate() {
    landscape = isLandscape(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    landscape = isLandscape(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text(widget.title),
        trailing: CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Text("旋转"),
            onPressed: () {
              if (!landscape) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight
                ]);
              } else {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
              }
              landscape = !landscape;
            }),
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
                      builder: (context) => MarkdownPage(
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

  void _loadMarkdown() async {
    var dio = defaultDio();
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
