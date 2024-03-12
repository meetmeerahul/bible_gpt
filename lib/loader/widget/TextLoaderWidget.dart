import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget TextLoaderWidget(
    double loaderWidth, double loaderHeight, double radius, bool darkMode) {
  return Shimmer.fromColors(
    baseColor:
        darkMode ? Colors.brown.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
    highlightColor: Colors.white,
    child: Container(
      width: loaderWidth,
      height: loaderHeight,
      decoration: BoxDecoration(
        color: darkMode
            ? Colors.brown.withOpacity(0.5)
            : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    ),
  );
}
