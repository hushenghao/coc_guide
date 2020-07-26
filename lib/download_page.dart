import 'dart:convert';

import 'package:coc_guide/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'coc_app.dart';

class DownloadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DownloadState();
}

class _DownloadState extends State<DownloadPage> {
  @override
  void initState() {
    super.initState();
    _loadList();
  }

  @override
  Widget build(BuildContext context) {
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
                largeTitle: Text("安装包下载"),
              ),
              CupertinoSliverRefreshControl(onRefresh: () => _loadList()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildItem(context, list[index]);
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

  Widget _buildItem(BuildContext context, _DownloadItem item) {
    return ListTile(
      onTap: () => openBrower(context, item.url),
      title: Text(item.title),
      subtitle: item.desc == null ? null : Text(item.desc),
      dense: false,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          rawUrl + item.icon,
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  List<_DownloadItem> list = new List();

  _loadList() async {
    var dio = defaultDio();
    try {
      Response response = await dio.get(rawUrl + "/json/download/v1.json");
      List<_DownloadItem> list = new List();
      json.decode(response.data).forEach((element) {
        var value = _DownloadItem(
            element["title"], element["desc"], element["icon"], element["url"]);
        list.add(value);
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

class _DownloadItem {
  _DownloadItem(this.title, this.desc, this.icon, this.url);

  String title;
  String desc;
  String icon;
  String url;
}
