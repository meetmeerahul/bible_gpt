
import 'package:flutter/cupertino.dart';


import '../../config/app_config.dart';
import '../Widget/TextLoaderWidget.dart';

Widget ChapterLoaderScreen({required double screenWidth,required double screenHeight,required bool darkMode}){
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight*(AppConfig().chapterScreenTopCategoryTextPadding/AppConfig().screenHeight),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: screenWidth*(AppConfig().chapterScreenLeftPadding/AppConfig().screenWidth)),
            child: TextLoaderWidget(screenWidth*0.25, screenHeight*(14/AppConfig().screenHeight), screenHeight*(14/AppConfig().screenHeight),darkMode),
          ),
          SizedBox(
            height: screenHeight*(AppConfig().chapterScreenBottomAllChapterTextPadding/AppConfig().screenHeight),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight*(20/AppConfig().screenHeight),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight*(20/AppConfig().screenHeight),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
                TextLoaderWidget((screenWidth*((AppConfig().screenWidth-AppConfig().chapterScreenLeftPadding-AppConfig().chapterScreenRightPadding-24-24)/AppConfig().screenWidth))/3, screenHeight*(180/AppConfig().screenHeight), screenHeight*(10/AppConfig().screenHeight),darkMode),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight*(20/AppConfig().screenHeight),
          ),
        ],
      ),
    ),
  );

}