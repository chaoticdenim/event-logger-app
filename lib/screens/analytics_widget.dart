import 'package:flutter/material.dart';

class AnalyticsWidget extends StatelessWidget {
  final Color color;

  AnalyticsWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}