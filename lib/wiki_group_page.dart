import 'dart:convert';

import 'package:coc_guide/tab_scale.dart';
import 'package:coc_guide/utils.dart';
import 'package:coc_guide/wiki_list.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'coc_app.dart';

///
/// Wiki 分组页
///
class WikiGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WikiGroupState();
}

class _WikiGroupState extends State<WikiGroupPage> {
  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Widget buildContent(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2,
          crossAxisCount: isLandscape(context) ? 4 : 2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            var item = list[index];
            return TabScale(
              onPressed: () => _toList(item),
              child: _buildItem(context, item),
              end: 0.9,
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            automaticallyImplyLeading: false,
            largeTitle: Text("Wiki"),
          ),
          CupertinoSliverRefreshControl(onRefresh: () => _loadList()),
          SliverSafeArea(
            top: false,
            sliver: buildContent(context),
          ),
        ],
      ),
    );
  }

  _toList(WikiItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return WikiListPage(this.widget.key, group: item);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, WikiItem item) {
    var color = randomColor(0.3);
    var textStyle = Theme.of(context).textTheme.bodyText1;
    return Padding(
      padding: EdgeInsets.all(3),
      child: Card(
        color: color,
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        shadowColor: color,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                item.en,
                style: textStyle.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5),
                child: Text(
                  item.zh,
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<WikiItem> list = new List();

  _loadList() async {
    var dio = defaultDio();
    try {
      Response response = await dio.get(rawUrl + "/json/wiki/group_v1.json");
      List<WikiItem> list = new List();
      json.decode(response.data).forEach((element) {
        list.add(WikiItem.formJson(element));
      });
      setState(() {
        this.list = list;
      });
    } catch (e) {
      Toast.show("网络加载失败", context);
      print(e);
    }
  }
}

class WikiItem {
  static WikiItem formJson(Map<String, dynamic> element) {
    return WikiItem(
        element["zh"], element["en"], element["icon"], element["url"]);
  }

  WikiItem(this.zh, this.en, this.icon, this.url);

  String zh;
  String en;
  String icon;
  String url;
}
