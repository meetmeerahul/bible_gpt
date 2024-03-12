import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/app_config.dart';

Widget AppBackgroundImageWidget(double screenWidth, double screenHeight,
    double imageWidth, double imageHeight, bool darkMode) {
  return SizedBox(
    width: screenWidth * (imageWidth / AppConfig().screenWidth),
    height: screenHeight * (imageHeight / AppConfig().screenHeight),
    child: SvgPicture.asset(
      darkMode
          ? AppConfig().appBackgroundDarkLogo
          : AppConfig().appBackgroundLightLogo,
      fit: BoxFit.scaleDown,
    ),
  );
}
