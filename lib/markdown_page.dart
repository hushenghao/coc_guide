import 'package:coc_guide/coc_app.dart';
import 'package:coc_guide/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            padding: EdgeInsets.all(10),
            child: Image(
              image: AssetImage("images/rotate.png"),
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (!landscape) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft,
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
              _openPage(href);
              return;
            }
            openBrower(context, href);
          },
          imageDirectory: rawUrl,
        ),
      ),
    );
  }

  _openPage(String href) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MarkdownPage(path: href),
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
