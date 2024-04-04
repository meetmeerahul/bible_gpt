import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Class/ChapterHomeListClass.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';
import 'ChapterHomeCardWidget.dart';

Widget RecentChapterListviewWidget(
    {required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required ChapterHomeListClass getChapterClass,
    required int currentIndex,
    required bool darkMode,
    required String getLanguageCode,
    required bool recent,
    required Function(ChapterHomeListClass) getCallBackFunction}) {
  print(" recent chapter $darkMode");
  return Container(
    child: Column(
      children: [
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (LanguageTextFile().getTextDirection(getLanguageCode) ==
                      TextDirection.rtl)
                  ? const SizedBox()
                  : SizedBox(
                      width: screenWidth *
                          ((currentIndex == 0 ? 16 : 0) /
                              AppConfig().screenWidth),
                    ),
              ChapterHomeCardWidget(
                  context: context,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  getChapterHomeClass: getChapterClass,
                  darkMode: darkMode,
                  recent: recent,
                  getLanguageCode: getLanguageCode,
                  isClick: (getResult) {
                    getCallBackFunction(getResult);
                  }),
              SizedBox(
                width: screenWidth * (24 / AppConfig().screenWidth),
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenHeight * (0 / AppConfig().screenHeight),
        ),
      ],
    ),
  );
}
