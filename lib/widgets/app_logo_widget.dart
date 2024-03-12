import 'package:flutter/material.dart';

import '../config/app_config.dart';

Widget AppLogoWidget(double screenWidth, double screenHeight, double imageWidth,
    double imageHeight, bool darkMode) {
  return Container(
    //width: screenWidth*(AppConfig().dashboardScreenAppLogoWidth/AppConfig().screenWidth),
    height: screenHeight *
        (AppConfig().dashboardScreenAppLogoHeight / AppConfig().screenHeight),
    alignment: Alignment.center,
    child: Image.asset(
      darkMode
          ? AppConfig().appLogoWidgetDarkImage
          : AppConfig().appLogoWidgetLightImage,
      fit: BoxFit.fitHeight,
    ),
  );
}
