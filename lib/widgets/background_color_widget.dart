import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/app_config.dart';
import '../config/language_text_file.dart';
import 'app_background_widget.dart';

Widget BackgroundColorWidget(
    {required double screenWidth,
    required double screenHeight,
    required bool getDarkMode,
    required String getLanguageCode,
    required bool imageWidget,
    required double? imageWidth,
    required double? imageHeight,
    required double? bottomImagePadding,
    required double? bottomCopyRightsContentPadding,
    required String imageContentFuture}) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: SvgPicture.asset(
          getDarkMode
              ? AppConfig().darkBackgroundColor
              : AppConfig().backgroundColor,
          fit: BoxFit.fill,
        ),
      ),
      imageWidget
          ? Container(
              width: screenWidth,
              height: screenHeight,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: AppBackgroundImageWidget(screenWidth, screenHeight,
                        imageWidth!, imageHeight!, getDarkMode),
                  ),
                  SizedBox(
                    height: screenHeight *
                        (bottomImagePadding! / AppConfig().screenHeight),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth *
                            (AppConfig().dashboardScreenLeftPadding /
                                AppConfig().screenWidth)),
                    child: Text(
                      //LanguageTextFile().getDashboardScreenBottomContentText(),
                      imageContentFuture,
                      textScaler: const TextScaler.linear(1.0),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenHeight *
                              (AppConfig().dashboardScreenCopyRightTextSize /
                                  AppConfig().screenHeight),
                          color: getDarkMode
                              ? AppConfig()
                                  .dashboardScreenBottomCopyRightTextDarkColor
                              : AppConfig()
                                  .dashboardScreenBottomCopyRightTextLightColor,
                          fontFamily: AppConfig().outfitFontRegular),
                    ),
                    // child: languageFutureWidget(
                    //     screenWidth: screenWidth,
                    //     screenHeight: screenHeight,
                    //     selectedLanguage: getLanguageCode,
                    //     getLanguageTranslatorMethod: imageContentFuture,
                    //     getFontSize:
                    //         AppConfig().dashboardScreenCopyRightTextSize,
                    //     getDarkMode: getDarkMode,
                    //     getTextAlign: TextAlign.center,
                    //     getTextColor: getDarkMode
                    //         ? AppConfig()
                    //             .dashboardScreenBottomCopyRightTextDarkColor
                    //         : AppConfig()
                    //             .dashboardScreenBottomCopyRightTextLightColor,
                    //     getFontFamily: AppConfig().outfitFontRegular,
                    //     getTextDirection: LanguageTextFile()
                    //         .getTextDirection(getLanguageCode),
                    //     getSoftWrap: true),
                    //child:languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getSelectedLanguageCode, getText: LanguageTextFile().getDashboardScreenCopyRightText(0), ,getTextStyle: TextStyle(fontSize: screenHeight*(AppConfig().dashboardScreenCopyRightTextSize/AppConfig().screenHeight),color: getDarkMode?AppConfig().dashboardScreenBottomCopyRightTextDarkColor:AppConfig().dashboardScreenBottomCopyRightTextLightColor,fontFamily: AppConfig().outfitFontRegular)),
                  ),
                  SizedBox(
                    height: screenHeight *
                        (bottomCopyRightsContentPadding! /
                            AppConfig().screenHeight),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    ],
  );
}
