import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/app_config.dart';

Widget BackArrowWidget(
    {required double screenWidth,
    required double screenHeight,
    required bool darkMode,
    required Function(bool) getCallBackFunction}) {
  return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          getCallBackFunction(true);
        },
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Container(
          width: screenWidth *
              (AppConfig().backArrowWidgetOuterWidth / AppConfig().screenWidth),
          height: screenWidth *
              (AppConfig().backArrowWidgetOuterHeight *
                  0.5 /
                  AppConfig().screenWidth),
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: screenWidth *
                (AppConfig().backArrowWidgetSizeWidth /
                    AppConfig().screenWidth),
            height: screenWidth *
                (AppConfig().backArrowWidgetSizeWidth /
                    AppConfig().screenWidth),
            child: SvgPicture.asset(
              AppConfig().backArrowWidgetIcon,
              fit: BoxFit.fitWidth,
              color: darkMode
                  ? AppConfig().backArrowDarkColor
                  : AppConfig().backArrowLightColor,
            ),
          ),
        ),
      ));
}
