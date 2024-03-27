import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget playerLoaderWidget(
    double loaderWidth, double loaderHeight, double radius, bool darkMode) {
  return Shimmer.fromColors(
    baseColor:
        darkMode ? Colors.brown.withOpacity(0) : Colors.grey.withOpacity(0),
    highlightColor: Colors.black54,
    child: Container(
      width: loaderWidth,
      height: loaderHeight,
      decoration: BoxDecoration(
        color:
            darkMode ? Colors.brown.withOpacity(0) : Colors.grey.withOpacity(0),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    ),
  );
}
