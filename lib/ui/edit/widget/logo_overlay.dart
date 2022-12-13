import 'dart:io';
import 'package:flutter/material.dart';

class LogoOverlay extends StatefulWidget {
  const LogoOverlay({
    Key? key,
    required this.logoFile,
  }) : super(key: key);

  final File logoFile;

  @override
  State<LogoOverlay> createState() => _LogoOverlayState();
}

class _LogoOverlayState extends State<LogoOverlay> {
  double logoOffsetX = 0.0;
  double logoOffsetY = 0.0;
  double logoStartX = 0.0;
  double logoStartY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: logoOffsetY,
      left: logoOffsetX,
      child: GestureDetector(
        onScaleStart: (details) {
          logoStartX = details.localFocalPoint.dx;
          logoStartY = details.localFocalPoint.dy;
        },
        onScaleUpdate: (details) {
          if (details.pointerCount < 2) {
            double xDiff = logoStartX - details.localFocalPoint.dx;
            double yDiff = logoStartY - details.localFocalPoint.dy;
            logoOffsetX = logoOffsetX - xDiff;
            logoOffsetY = logoOffsetY - yDiff;
            logoStartX = details.localFocalPoint.dx;
            logoStartY = details.localFocalPoint.dy;
          }
          setState(() {});
        },
        child: SizedBox(
          height: 180.0,
          width: 180.0,
          child: Image.file(
            widget.logoFile,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
