import 'package:flutter/cupertino.dart';

import '../../config/app_config.dart';
import '../Widget/TextLoaderWidget.dart';

Widget DetailLoaderScreen(
    double screenWidth, double screenHeight, bool darkMode) {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight *
                (AppConfig().categoryDetailScreenTopPadding /
                    AppConfig().screenHeight),
          ),
          SizedBox(
            height: screenHeight *
                (AppConfig().categoryDetailScreenTopPadding /
                    AppConfig().screenHeight),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth *
                    (AppConfig().categoryDetailScreenHorizontalPadding /
                        AppConfig().screenWidth)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextLoaderWidget(
                    screenWidth *
                        ((AppConfig().backArrowWidgetOuterWidth) /
                            AppConfig().screenWidth),
                    screenHeight * (30 / AppConfig().screenHeight),
                    screenHeight * (10 / AppConfig().screenHeight),
                    darkMode),
                Container(
                  child: Column(
                    children: [
                      TextLoaderWidget(
                          screenWidth * 0.4,
                          screenHeight * (15 / AppConfig().screenHeight),
                          screenHeight * (10 / AppConfig().screenHeight),
                          darkMode),
                      SizedBox(
                        height: screenHeight * (7 / AppConfig().screenHeight),
                      ),
                      TextLoaderWidget(
                          screenWidth * 0.4,
                          screenHeight * (15 / AppConfig().screenHeight),
                          screenHeight * (10 / AppConfig().screenHeight),
                          darkMode),
                    ],
                  ),
                ),
                TextLoaderWidget(
                    screenWidth *
                        ((AppConfig().backArrowWidgetOuterWidth) /
                            AppConfig().screenWidth),
                    screenHeight * (30 / AppConfig().screenHeight),
                    screenHeight * (10 / AppConfig().screenHeight),
                    darkMode),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight *
                (AppConfig().categoryDetailScreenTopChapterPadding /
                    AppConfig().screenHeight),
          ),
          SizedBox(
            height: screenHeight *
                (AppConfig().categoryDetailScreenTopPadding /
                    AppConfig().screenHeight),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth *
                    (AppConfig().categoryDetailScreenHorizontalPadding /
                        AppConfig().screenWidth)),
            child: TextLoaderWidget(
                screenWidth * 0.5,
                screenHeight * (15 / AppConfig().screenHeight),
                screenHeight * (10 / AppConfig().screenHeight),
                darkMode),
          ),
          SizedBox(
            height: screenHeight *
                (AppConfig().categoryDetailScreenTopListviewPadding /
                    AppConfig().screenHeight),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth *
                    (AppConfig().categoryDetailScreenHorizontalPadding /
                        AppConfig().screenWidth)),
            child: TextLoaderWidget(
                screenWidth,
                screenHeight * (300 / AppConfig().screenHeight),
                screenHeight * (10 / AppConfig().screenHeight),
                darkMode),
          ),
          SizedBox(
            height: screenHeight * (20 / AppConfig().screenHeight),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth *
                    (AppConfig().categoryDetailScreenHorizontalPadding /
                        AppConfig().screenWidth)),
            child: TextLoaderWidget(
                screenWidth,
                screenHeight * (300 / AppConfig().screenHeight),
                screenHeight * (10 / AppConfig().screenHeight),
                darkMode),
          ),
          SizedBox(
            height: screenHeight * (20 / AppConfig().screenHeight),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth *
                    (AppConfig().categoryDetailScreenHorizontalPadding /
                        AppConfig().screenWidth)),
            child: TextLoaderWidget(
                screenWidth,
                screenHeight * (300 / AppConfig().screenHeight),
                screenHeight * (10 / AppConfig().screenHeight),
                darkMode),
          ),
          SizedBox(
            height: screenHeight * (20 / AppConfig().screenHeight),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth *
                    (AppConfig().categoryDetailScreenHorizontalPadding /
                        AppConfig().screenWidth)),
            child: TextLoaderWidget(
                screenWidth,
                screenHeight * (300 / AppConfig().screenHeight),
                screenHeight * (10 / AppConfig().screenHeight),
                darkMode),
          ),
          SizedBox(
            height: screenHeight * (20 / AppConfig().screenHeight),
          ),
          SizedBox(
            height: screenHeight *
                (AppConfig().categoryDetailScreenTopListviewPadding /
                    AppConfig().screenHeight),
          ),
        ],
      ),
    ),
  );
}
