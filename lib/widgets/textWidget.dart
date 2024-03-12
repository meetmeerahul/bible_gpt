import 'package:flutter/cupertino.dart';

import '../config/app_config.dart';

Widget TextWidget({
  required double screenWidth,
  required double screenHeight,
  required String getText,
  required double fontSize,
  required TextAlign getTextAlign,
  required Color getTextColor,
  required String getFontFamily,
  required TextDirection getTextDirection,
  required bool getSoftWrap,
}) {
  return Text(
    getText,
    textScaler: const TextScaler.linear(1.0),
    textAlign: getTextAlign,
    style: TextStyle(
        height: 0,
        fontSize: screenHeight * (fontSize / AppConfig().screenHeight),
        color: getTextColor,
        fontFamily: getFontFamily),
    textDirection: getTextDirection,
    softWrap: getSoftWrap,
    overflow: getSoftWrap ? null : TextOverflow.ellipsis,
  );
}
