import 'package:flutter/material.dart';

class ConnectionErrorIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const ConnectionErrorIcon({
    super.key,
    this.size = 80.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // We use a Container or a DecoratedBox if we want to add
    // background glows or shadows later.
    return Icon(
      Icons.cloud_off_rounded,
      size: size,
      color: color ?? Colors.redAccent,
    );
  }
}