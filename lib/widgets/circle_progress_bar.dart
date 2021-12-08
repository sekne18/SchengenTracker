import 'package:flutter/material.dart';

class CircleProgressBar extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;

  const CircleProgressBar({
    required Key key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.value,
  }) : super(key: key);

  @override
  CircleProgressBarState createState() {
    return CircleProgressBarState();
  }
}

class CircleProgressBarState extends State<CircleProgressBar> {
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.widget.backgroundColor;
    final foregroundColor = this.widget.foregroundColor;
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        child: Container(),
        foregroundPainter: CircleProgressBarPainter(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          percentage: this.widget.value,
        ),
      ),
    );
  }
}
