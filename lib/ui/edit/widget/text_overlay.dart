import 'package:flutter/material.dart';

class TextOverlay extends StatefulWidget {
  const TextOverlay({
    Key? key,
    required this.textWidget,
  }) : super(key: key);

  final Widget textWidget;

  @override
  State<TextOverlay> createState() => _TextOverlayState();
}

class _TextOverlayState extends State<TextOverlay> {
  double textOffsetX = 0.0;
  double textOffsetY = 0.0;
  double textStartX = 0.0;
  double textStartY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: textOffsetY,
      left: textOffsetX,
      child: GestureDetector(
        onScaleStart: (details) {
          textStartX = details.localFocalPoint.dx;
          textStartY = details.localFocalPoint.dy;
        },
        onScaleUpdate: (details) {
          if (details.pointerCount < 2) {
            double xDiff = textStartX - details.localFocalPoint.dx;
            double yDiff = textStartY - details.localFocalPoint.dy;
            textOffsetX = textOffsetX - xDiff;
            textOffsetY = textOffsetY - yDiff;
            textStartX = details.localFocalPoint.dx;
            textStartY = details.localFocalPoint.dy;
          }
          setState(() {});
        },
        child: widget.textWidget,
      ),
    );
  }
}
