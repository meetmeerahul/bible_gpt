import 'package:bible_gpt/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../Class/ChapterHomeListClass.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';

Widget ChapterHomeCardWidget(
    {required double screenWidth,
    required double screenHeight,
    required ChapterHomeListClass getChapterHomeClass,
    required bool darkMode,
    required bool recent,
    required String getLanguageCode,
    required Function(ChapterHomeListClass) isClick}) {
  return Container(
    child: Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(
                      screenWidth * (6 / AppConfig().screenWidth))),
                  child: SvgPicture.asset(
                    darkMode
                        ? AppConfig().darkCardBackgroundColor
                        : AppConfig().cardBackgroundColor,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              isClick(getChapterHomeClass);
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    screenWidth * (6 / AppConfig().screenWidth))),
              ),
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Container(
              width: (screenWidth *
                      ((AppConfig().screenWidth -
                              AppConfig().chapterScreenLeftPadding -
                              AppConfig().chapterScreenRightPadding -
                              24 -
                              24) /
                          AppConfig().screenWidth)) /
                  3,
              height: screenHeight * (134 / AppConfig().screenHeight),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                    screenWidth * (6 / AppConfig().screenWidth))),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: darkMode
                      ? const Color(0xFF000000)
                      : const Color(0xFFFFF7D8),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      //height: (screenHeight * (200 / AppConfig().screenHeight)),
                      // width: (screenWidth * (200 / AppConfig().screenWidth)),
                      child: SvgPicture.asset("assets/svg/book_cover.svg"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: (screenWidth * (14 / AppConfig().screenWidth)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:
                                (screenWidth * (120 / AppConfig().screenWidth)),
                          ),
                          SvgPicture.asset(
                              height: (screenHeight *
                                  (20 / AppConfig().screenHeight)),
                              width: (screenWidth *
                                  (20 / AppConfig().screenWidth)),
                              "assets/svg/cross.svg"),
                          Text(
                            getLanguageCode == 'en'
                                ? "The Book of"
                                : "की किताब",
                            style: TextStyle(
                              fontSize: (screenHeight *
                                  (10 / AppConfig().screenHeight)),
                              color: const Color(0xFFA49A78),
                            ),
                          ),
                          GradientText(
                            textAlign: TextAlign.center,
                            colors: const [
                              Color(0xFFFFD05B),
                              Color(0xFFBE7C12),
                            ],
                            getLanguageCode == 'en' ? 'Judges' : "न्यायाधीशों",
                            style: TextStyle(
                                fontSize: (screenHeight *
                                    (16 / AppConfig().screenHeight))),
                          ),
                          Text(
                            getLanguageCode == 'en' ? "Bible" : "बाइबिल",
                            style: TextStyle(
                              fontSize: (screenHeight *
                                  (10 / AppConfig().screenHeight)),
                              color: const Color(0xFFA49A78),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
