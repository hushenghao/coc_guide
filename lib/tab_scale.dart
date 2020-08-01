import 'package:flutter/widgets.dart';

class TabScale extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onPressed;
  final double begin;
  final double end;

  TabScale(
      {Key key,
      this.child,
      this.duration = const Duration(milliseconds: 200),
      this.begin = 1.0,
      this.end = 0.95,
      this.onPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabScaleState();
}

class _TabScaleState extends State<TabScale>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
  }

  _onPressedChanged(bool isPressed) {
    if (isPressed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scale = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut);
    var child = ScaleTransition(
      scale: new Tween(begin: widget.begin, end: widget.end).animate(scale),
      child: widget.child,
    );
    return GestureDetector(
      onPanDown: (details) {
        _onPressedChanged(true);
      },
      onPanEnd: (details) {
        _onPressedChanged(false);
      },
      onPanCancel: () {
        _onPressedChanged(false);
      },
      onTap: widget.onPressed,
      child: child,
    );
  }
}
