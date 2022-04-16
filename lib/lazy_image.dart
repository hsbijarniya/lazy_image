library lazy_image;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    Size size = context.size ?? MediaQuery.of(context).size;

    return Image.network(
      "$url?height=${size.height}&width=${size.width}&org_if_sml=1&func=bound",
      fit: fit,
      height: height,
      width: width,
    );
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
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: (visibilityInfo) {
        if (isVisible) return;

        visiblePercentage = visibilityInfo.visibleFraction * 100;
        isVisible = visiblePercentage > 0.5;

        if (isVisible) {
          setState(() {});
        }
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: isVisible
            ? SizedImage(
                widget.url,
                height: widget.height,
                width: widget.width,
                fit: widget.fit,
              )
            : null,
      ),
    );
  }
}
