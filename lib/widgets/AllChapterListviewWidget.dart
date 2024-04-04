import 'package:flutter/material.dart';

import '../Class/ChapterHomeListClass.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';
import 'ChapterHomeCardWidget.dart';

Widget AllChapterListviewWidget(
    {required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required List<ChapterHomeListClass> getChapterList,
    required bool darkMode,
    required String getLanguageCode,
    required bool recent,
    required Function(ChapterHomeListClass) getCallBackFunction}) {
  return SizedBox(
    width: screenWidth,
    child: Column(
      children: [
        IntrinsicHeight(
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth *
                    (AppConfig().chapterScreenLeftPadding /
                        AppConfig().screenWidth)),
            child: Row(
              textDirection:
                  LanguageTextFile().getTextDirection(getLanguageCode),
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getChapterList.isNotEmpty
                    ? ChapterHomeCardWidget(
                        context: context,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        getChapterHomeClass: getChapterList[0],
                        darkMode: darkMode,
                        recent: recent,
                        getLanguageCode: getLanguageCode,
                        isClick: (getResult) {
                          getCallBackFunction(getResult);
                        })
                    : const SizedBox(),
                SizedBox(
                  width: screenWidth * (16 / AppConfig().screenWidth),
                ),
                getChapterList.length > 1
                    ? ChapterHomeCardWidget(
                        context: context,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        getChapterHomeClass: getChapterList[1],
                        darkMode: darkMode,
                        recent: recent,
                        getLanguageCode: getLanguageCode,
                        isClick: (getResult) {
                          getCallBackFunction(getResult);
                        })
                    : const SizedBox(),
                SizedBox(
                  width: screenWidth * (16 / AppConfig().screenWidth),
                ),
                getChapterList.length > 2
                    ? ChapterHomeCardWidget(
                        context: context,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        getChapterHomeClass: getChapterList[2],
                        darkMode: darkMode,
                        recent: recent,
                        getLanguageCode: getLanguageCode,
                        isClick: (getResult) {
                          getCallBackFunction(getResult);
                        })
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * (20 / AppConfig().screenHeight),
        ),
      ],
    ),
  );
}
