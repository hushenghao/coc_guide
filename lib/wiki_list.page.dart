import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coc_guide/markdown_page.dart';
import 'package:coc_guide/tab_scale.dart';
import 'package:coc_guide/utils.dart';
import 'package:coc_guide/wiki_group_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    _loadList();
  }

  @override
  Widget build(BuildContext context) {
    var group = widget.group;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            automaticallyImplyLeading: false,
            largeTitle: Text(group.en),
          ),
          CupertinoSliverRefreshControl(onRefresh: () => _loadList()),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildGroup(context, list[index]);
                },
                childCount: list.length,
              ),
            ),
          ),
        ],
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
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.85,
            crossAxisCount: isLandscape(context) ? 8 : 4,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            var item = list[index];
            return TabScale(
              child: _buildItem(context, item),
              onPressed: () => _openWiki(item),
              end: 0.9,
            );
          },
        ),
      ],
    );
  }

  List<_WikiGroup> list = new List();

  _loadList() async {
    var dio = defaultDio();
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
        child: Column(
          children: <Widget>[
            Image(
              image: CachedNetworkImageProvider(rawUrl + item.icon),
              height: 67,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: Center(
                child: Text(
                  item.zh,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openWiki(WikiItem item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MarkdownPage(path: item.url, title: item.en);
    }));
  }
}

class _WikiGroup {
  _WikiGroup(this.group, this.list);

  String group;
  List<WikiItem> list;
}
