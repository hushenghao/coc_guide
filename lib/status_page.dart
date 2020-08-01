import 'package:flutter/cupertino.dart';

class StatusPage extends StatefulWidget {
  final Widget child;
  final WidgetBuilder loading;
  final WidgetBuilder error;

  StatusPage(
      {Key key,
      @required this.child,
      this.error = buildSimpleError,
      this.loading = buildSimpleLoading})
      : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();

  static Widget buildSimpleLoading(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(),
    );
  }

  static Widget buildSimpleError(BuildContext context) {
    return Center(
      child: Text("Error"),
    );
  }
}

const _normal = 0;
const _loading = 1;
const _error = -1;

class _StatusPageState extends State<StatusPage> {
  var status = _normal;

  @override
  Widget build(BuildContext context) {
    WidgetBuilder builder = null;
    switch (status) {
      case _normal:
        break;
      case _loading:
        builder = widget.loading;
        break;
      case _error:
        builder = widget.error;
        break;
    }
    if (builder == null) {
      print("=====");
      return widget.child;
    }
    print("object");
    return builder.call(context);
  }
}
