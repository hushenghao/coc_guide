import 'package:audioplayers/audio_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coc_guide/tab_scale.dart';
import 'package:coc_guide/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'coc_app.dart';

class HomePage extends StatelessWidget {
  List<_HomeItem> buildItem(BuildContext context) => [
        _RouteItem("游戏数据", "在这里，你可以看到各个兵种、法术、建筑的数据属性，游戏规划由自己掌握。",
            rawUrl + "/res/home3.jpg", "/wiki", context),
        _RouteItem("安装包下载", "各渠道安装包下载链接，点击链接自动进入对应渠道官网或下载链接。",
            rawUrl + "/res/update.jpg", "/download", context),
//        _HomeItem("阵型分享", "从2019年6月更新起，部落冲突新增了阵型链接功能，这让阵型网站的开设变得更加容易。",
//            RAW_URL + "/res/home2.jpg"),
//        _HomeItem("信息查询", "目前有查询鱼情、部落和玩家这几个功能。比如说查询玩家页面包括基本信息、科技和成就。",
//            rawUrl + "/res/clashofclans.jpg", onPressed: () {
//          Navigator.of(context)
//              .push(CupertinoPageRoute(builder: (context) => WikiGroupPage()));
//        }),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView.custom(
          childrenDelegate: SliverChildListDelegate.fixed(
            [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: CachedNetworkImage(
                        imageUrl: rawUrl + "/res/coc_logo.png",
                        height: 67,
                      ),
                      onPressed: () => _play(),
                    ),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: CachedNetworkImage(
                          imageUrl: rawUrl + "/res/github_logo.png",
                          height: 29,
                          color: randomColor(0.8),
                        ),
                        onPressed: () => openBrower(context, githubUrl)),
                  ],
                ),
              ),
              for (var value in buildItem(context)) ...[_CardItem(value)],
              CupertinoButton(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 40),
                child: FlutterLogo(
                  size: 37,
                  style: FlutterLogoStyle.stacked,
                ),
                onPressed: () {
                  Toast.show(" 😏 ", context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _play() async {
    var cache = AudioCache(prefix: "audio/");
    cache.play("loading_screen_jingle.ogg");
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

class _CardItem extends StatefulWidget {
  final _HomeItem item;

  _CardItem(this.item, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardItemState();
}

class _CardItemState extends State<_CardItem> {
  final _color = randomColor(0.5);

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: SizedBox(
        height: 360,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          clipBehavior: Clip.antiAlias,
          elevation: 16,
          color: _color,
          shadowColor: _color,
          child: Column(
            children: <Widget>[
              Image(
                height: 260,
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(widget.item.imgUrl),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            widget.item.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          widget.item.subTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return TabScale(
      child: _buildContent(context),
      onPressed: widget.item.onPressed,
    );
  }
}
