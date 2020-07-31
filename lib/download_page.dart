import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'coc_app.dart';
import 'utils.dart';

///
/// 下载页
///
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
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverNavigationBar(
            automaticallyImplyLeading: false,
            largeTitle: Text("安装包下载"),
          ),
          CupertinoSliverRefreshControl(onRefresh: () => _loadList()),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2.3,
                  crossAxisCount: isLandscape(context) ? 4 : 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildItem(context, list[index]);
                  },
                  childCount: list.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _DownloadItem item) {
    double size = 55;
    return CupertinoButton(
      onPressed: () => _itemClick(context, item),
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image(
                  image: CachedNetworkImageProvider(rawUrl + item.icon),
                  fit: BoxFit.cover,
                ),
                height: size,
                width: size,
                clipBehavior: Clip.antiAlias,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.blueGrey.withAlpha(80), width: 0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: size,
                width: size,
                clipBehavior: Clip.antiAlias,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                item.title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _itemClick(BuildContext context, _DownloadItem item) {
    if (item.desc == null) {
      openBrower(context, item.url);
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('提示'),
        content: Text(item.desc),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text("取消"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              openBrower(context, item.url);
              Navigator.pop(context);
            },
            child: Text("我知道了"),
          ),
        ],
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
