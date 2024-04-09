import 'package:bible_gpt/signInScreen/signinScreen.dart';
import 'package:flutter/material.dart';

import '../chapterScreen/bottomNavigationBarScreen.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';

Widget MenuBarCategoryWidget(
    {required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required bool getDarkMode,
    required String getLanguageCode,
    required int currentCategory,
    required String chapterText,
    required Function(int) selectedCategoryFunction}) {
  return Container(
    width: screenWidth * (346 / AppConfig().screenWidth),
    padding: EdgeInsets.symmetric(
        horizontal: screenWidth * (16 / AppConfig().screenWidth)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight * (15 / AppConfig().screenHeight),
        ),
        Container(
          width: screenWidth * ((346 - 16 - 16) / AppConfig().screenWidth),
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              print("chapter click");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const bottomNavigationBarScreen(
                        currentPage: 1,
                      )));
              selectedCategoryFunction(0);
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * (10 / AppConfig().screenHeight),
                ),
                SizedBox(
                  width:
                      screenWidth * ((346 - 16 - 16) / AppConfig().screenWidth),
                  child: Text(
                    chapterText,
                    textScaler: const TextScaler.linear(1.0),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaler.scale(
                          (screenHeight * (14 / AppConfig().screenHeight))),
                      color: currentCategory == 0
                          ? (getDarkMode
                              ? const Color(0xFFFBE4AB)
                              : const Color(0xFF805002))
                          : (getDarkMode
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF8A8A8A)),
                      fontFamily: AppConfig().outfitFontRegular,
                    ),
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                  ),
                ),
                SizedBox(
                  height: screenHeight * (10 / AppConfig().screenHeight),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * (15 / AppConfig().screenHeight),
        ),
      ],
    ),
  );
}
