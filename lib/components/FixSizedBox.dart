import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FixSizedBox extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  FixSizedBox({required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth ?? context.width() * 0.5),
      child: child,
    ).center();
  }
}
