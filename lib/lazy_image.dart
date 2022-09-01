library lazy_image;

import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
// import 'package:visibility_detector/visibility_detector.dart';

List<List<int>> sizeBuckets = [
  for (int i = 1; i < 9; i++) [256 * i, 256 * i],
];

class SizedImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? height, width;
  const SizedImage(
    this.url, {
    Key? key,
    this.fit,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final window = WidgetsBinding.instance.window;

    return LayoutBuilder(builder: ((context, constraints) {
      Size size;

      size = Size(
        constraints.maxWidth == double.infinity
            ? constraints.maxWidth
            : constraints.maxWidth.toInt().toDouble(),
        constraints.maxHeight == double.infinity
            ? constraints.maxHeight
            : constraints.maxHeight.toInt().toDouble(),
      );

      // debugPrint("obtaining size height=${size.height}&width=${size.width}");

      return Image(
        image: (url.contains('http://') || url.contains('https://')
            ? NetworkImage(
                "$url?height=${size.height * window.devicePixelRatio}&width=${size.width * window.devicePixelRatio}&org_if_sml=1&func=bound")
            : AssetImage(url)) as ImageProvider,
        fit: fit,
        height: height,
        width: width,
      );
    }));
  }
}

class LazyImage extends StatefulWidget {
  final String url;
  final BoxFit? fit;
  final double? height, width;
  const LazyImage(
    this.url, {
    Key? key,
    this.fit,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<LazyImage> {
  double visiblePercentage = 0;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    // return VisibilityDetector(
    //   key: Key(widget.url),
    //   onVisibilityChanged: (visibilityInfo) {
    //     if (isVisible) return;

    //     visiblePercentage = visibilityInfo.visibleFraction * 100;
    //     isVisible = visiblePercentage > 0;

    //     if (isVisible) {
    //       setState(() {});
    //     }
    //   },
    //   child:
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: isVisible
          ? SizedImage(
              widget.url,
              height: widget.height,
              width: widget.width,
              fit: widget.fit,
            )
          : SizedBox(
              height: 1,
              width: 1,
            ),
      // ),
    );
  }
}
