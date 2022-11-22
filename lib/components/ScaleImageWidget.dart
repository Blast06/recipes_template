import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ScaleImageWidget extends StatefulWidget {
  final Widget child;
  final double? height;
  final double? width;
  final bool? isScaleImage;

  const ScaleImageWidget({required this.child, this.height, this.width, this.isScaleImage = true});

  @override
  _ScaleImageWidgetState createState() => _ScaleImageWidgetState();
}

class _ScaleImageWidgetState extends State<ScaleImageWidget> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? context.width(),
      height: widget.height ?? context.height() * 0.7,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius)),
      child: widget.isScaleImage.validate()
          ? MouseRegion(
              onEnter: (s) {
                setState(() => scale = 1.1);
              },
              onExit: (s) {
                setState(() => scale = 1.0);
              },
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 250),
                child: widget.child,
              ),
            )
          : widget.child,
    );
  }
}
