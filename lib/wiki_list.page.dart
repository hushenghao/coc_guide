import 'dart:convert';

import 'package:coc_guide/markdown_page.dart';
import 'package:coc_guide/utils.dart';
import 'package:coc_guide/wiki_group_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

import 'coc_app.dart';

///
/// Wiki 列表
///
class WikiListPage extends StatefulWidget {
  final WikiItem group;

  WikiListPage(Key key, {this.group}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WikiListState();
}

class _WikiListState extends State<WikiListPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _loadList();
  }

  @override
  Widget build(BuildContext context) {
    var group = widget.group;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: CupertinoPageScaffold(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverNavigationBar(
                automaticallyImplyLeading: false,
                largeTitle: Text(group.en),
              ),
              CupertinoSliverRefreshControl(onRefresh: () => _loadList()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildGroup(context, list[index]);
                  },
                  childCount: list.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(BuildContext context, _WikiGroup item) {
    var list = item.list;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10, left: 20),
          child: Text(
            item.group,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          shrinkWrap: true,
          controller: TrackingScrollController(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.85,
            crossAxisCount: 4,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildItem(context, list[index]);
          },
        ),
      ],
    );
  }

  List<_WikiGroup> list = new List();

  _loadList() async {
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    try {
      Response response = await dio.get(rawUrl + widget.group.url);
      List<_WikiGroup> list = new List();
      json.decode(response.data).forEach((element) {
        List<WikiItem> itemList = new List();
        element["list"].forEach((item) {
          itemList.add(WikiItem.formJson(item));
        });

        var group = _WikiGroup(element["group"], itemList);
        list.add(group);
      });
      setState(() {
        this.list = list;
      });
    } catch (e) {
      Toast.show("网络加载失败", context);
      print(e);
    }
  }

  Widget _buildItem(BuildContext context, WikiItem item) {
    var color = randomColor(0.3);
    return Padding(
      padding: EdgeInsets.only(left: 3, right: 3, bottom: 6),
      child: Card(
        elevation: 8,
        color: color,
        clipBehavior: Clip.antiAlias,
        shadowColor: color,
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: InkWell(
          onTap: () => _openWiki(item),
          child: Column(
            children: <Widget>[
              Image.network(
                rawUrl + item.icon,
                fit: BoxFit.fitWidth,
                height: 73,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    item.zh,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openWiki(WikiItem item) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
      return MarkdownPage(path: item.url, title: item.en);
    }));
  }
}

class _WikiGroup {
  _WikiGroup(this.group, this.list);

  String group;
  List<WikiItem> list;
}
