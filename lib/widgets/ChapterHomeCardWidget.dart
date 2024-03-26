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
        const Positioned.fill(
          child: Column(
            children: [
              // Expanded(
              //   child: SvgPicture.asset(
              //     "assets/svg/book_cover.svg",
              //     fit: BoxFit.fill,
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              print("Chhapter clicked : $getChapterHomeClass");
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
              alignment: Alignment.topCenter,
              width: (screenWidth *
                      ((AppConfig().screenWidth -
                              AppConfig().chapterScreenLeftPadding -
                              AppConfig().chapterScreenRightPadding -
                              16 -
                              16) /
                          AppConfig().screenWidth)) /
                  3,
              //  height: screenHeight * (134 / AppConfig().screenHeight),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(
              //       screenWidth * (6 / AppConfig().screenWidth))),
              // ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: (screenWidth * (10 / AppConfig().screenWidth))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: (screenHeight * (50 / AppConfig().screenHeight)),
                    ),
                    SvgPicture.asset(
                        height:
                            (screenHeight * (20 / AppConfig().screenHeight)),
                        width: (screenWidth * (20 / AppConfig().screenWidth)),
                        "assets/svg/cross.svg"),
                    Text(
                      getLanguageCode == 'en' ? "The Book of" : "की किताब",
                      style: TextStyle(
                        fontSize:
                            (screenHeight * (10 / AppConfig().screenHeight)),
                        color: const Color(0xFFA49A78),
                      ),
                    ),
                    SizedBox(
                      //width: (screenWidth * (30 / AppConfig().screenWidth)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                                (screenWidth * (15 / AppConfig().screenWidth)),
                            right:
                                (screenWidth * (15 / AppConfig().screenWidth))),
                        child: GradientText(
                          textAlign: TextAlign.center,
                          colors: const [
                            Color(0xFFFFD05B),
                            Color(0xFFBE7C12),
                          ],
                          getChapterHomeClass.name ??
                              '', // Provide a default value if getChapterHomeClass.name is null
                          style: TextStyle(
                              fontSize: (screenHeight *
                                  (16 / AppConfig().screenHeight))),
                        ),
                      ),
                    ),
                    Text(
                      getLanguageCode == 'en' ? "Bible" : "बाइबिल",
                      style: TextStyle(
                        fontSize:
                            (screenHeight * (10 / AppConfig().screenHeight)),
                        color: const Color(0xFFA49A78),
                      ),
                    ),
                    SizedBox(
                      height: (screenHeight * (20 / AppConfig().screenHeight)),
                    ),
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
