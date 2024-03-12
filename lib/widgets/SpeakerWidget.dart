import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/app_config.dart';

Widget SpeakerWidget(
    {required double screenWidth,
    required double screenHeight,
    required bool getDarkMode,
    required bool isPlayed,
    required Function(bool) callBackFunction}) {
  return Container(
    child: TextButton(
      onPressed: () {
        callBackFunction(true);
      },
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Container(
        width: screenWidth *
            ((AppConfig().speakerWidgetIconOuterWidth + 10) /
                AppConfig().screenWidth),
        height: screenWidth *
            ((AppConfig().speakerWidgetIconOuterWidth + 10) /
                AppConfig().screenWidth),
        alignment: Alignment.center,
        child: Container(
          width: screenWidth *
              (AppConfig().speakerWidgetIconOuterWidth /
                  AppConfig().screenWidth),
          height: screenWidth *
              (AppConfig().speakerWidgetIconOuterWidth /
                  AppConfig().screenWidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                screenWidth *
                    (AppConfig().speakerWidgetIconOuterWidth /
                        AppConfig().screenWidth),
              ),
            ),
            color: AppConfig()
                .speakerWidgetIconBackgroundColor
                .withOpacity(getDarkMode ? 0.16 : 0.4),
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: screenWidth *
                (AppConfig().speakerWidgetIconWidth / AppConfig().screenWidth),
            height: screenWidth *
                (AppConfig().speakerWidgetIconWidth / AppConfig().screenWidth),
            child: SvgPicture.asset(
              isPlayed
                  ? AppConfig().speakerOnWidgetIcon
                  : AppConfig().speakerWidgetIcon,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    ),
  );
}
