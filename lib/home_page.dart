import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coc_app.dart';

class HomePage extends StatelessWidget {
  List<_HomeItem> buildItem(BuildContext context) => [
        _RouteItem("安装包下载", "各渠道安装包下载链接，点击链接自动进入对应渠道官网或下载链接。",
            RAW_URL + "res/update.jpg", "/download", context),
        _RouteItem("游戏数据", "在这里，你可以看到各个兵种、法术、建筑的数据属性，游戏规划由自己掌握。",
            RAW_URL + "res/home3.jpg", "/wiki", context),
        _HomeItem("阵型分享", "从2019年6月更新起，部落冲突新增了阵型链接功能，这让阵型网站的开设变得更加容易。",
            RAW_URL + "res/home2.jpg"),
        _HomeItem("信息查询", "目前有查询鱼情、部落和玩家这几个功能。比如说查询玩家页面包括基本信息、科技和成就。",
            RAW_URL + "res/clashofclans.jpg"),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              automaticallyImplyLeading: false,
              largeTitle: Text("COC Guide"),
//              trailing: Icon(CupertinoIcons.settings_solid),
            ),
            SliverPadding(
              padding: MediaQuery.of(context).padding,
              sliver: SliverList(
                // ignore: missing_return
                delegate: SliverChildListDelegate.fixed([
                  for (var value in buildItem(context)) _CardItem(value),
                  CupertinoButton(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Icon(CupertinoIcons.settings),
                    onPressed: () {
                      print('object');
                    },
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HomeItem {
  const _HomeItem(this.title, this.subTitle, this.imgUrl, {this.onPressed})
      : assert(title != null),
        assert(subTitle != null),
        assert(imgUrl != null);

  final String title;
  final String subTitle;
  final String imgUrl;
  final VoidCallback onPressed;
}

class _RouteItem extends _HomeItem {
  _RouteItem(String title, String subTitle, String imgUrl, String route,
      BuildContext context)
      : super(title, subTitle, imgUrl, onPressed: () {
          Navigator.of(context).pushNamed(route);
        });
}

class _CardItem extends StatelessWidget {
  final _HomeItem item;

  _CardItem(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: SizedBox(
        height: 360,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          clipBehavior: Clip.antiAlias,
          elevation: 16,
          shadowColor: Colors.black45,
          child: InkWell(
            highlightColor: Theme.of(context).accentColor.withOpacity(0.2),
            onTap: item.onPressed,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 260,
                  child: Ink.image(
                    fit: BoxFit.cover,
                    image: NetworkImage(item.imgUrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 21, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        item.subTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
