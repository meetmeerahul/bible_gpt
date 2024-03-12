import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/app_config.dart';
import '../../config/language_text_file.dart';

ElevatedButton SecondaryButton(
    {required double screenWidth,
    required double screenHeight,
    required double buttonWidth,
    required double buttonHeight,
    required bool getDarkMode,
    required String buttonText,
    required String getLanguageCode,
    required String? iconPath,
    required double? iconWidth,
    required double? iconHeight,
    required Function(bool) buttonPressedFunction}) {
  return ElevatedButton(
    onPressed: () {
      buttonPressedFunction(true);
    },
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide(
          width: screenWidth * (1 / AppConfig().screenWidth),
          color:
              getDarkMode ? const Color(0xFFDB7F5E) : const Color(0xFF9A3524)),
      //fixedSize: Size(screenWidth*(buttonWidth/AppConfig().screenWidth), screenHeight*(buttonHeight/AppConfig().screenHeight),),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(screenHeight *
            (AppConfig().primaryButtonCurveSize / AppConfig().screenHeight))),
      ),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * (19 / AppConfig().screenWidth)),
      //width: screenWidth*(buttonWidth/AppConfig().screenWidth),
      height: screenHeight * (buttonHeight / AppConfig().screenHeight),
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Row(
        textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // languageFutureWidget(
          //     screenWidth: screenWidth,
          //     screenHeight: screenHeight,
          //     selectedLanguage: getLanguageCode,
          //     getLanguageTranslatorMethod: buttonTextFunction,
          //     getFontSize: AppConfig().primaryButtonTextSize,
          //     getDarkMode: false,
          //     getTextAlign: TextAlign.center,
          //     getTextColor: getDarkMode
          //         ? const Color(0xFFDB7F5E)
          //         : const Color(0xFFAB2E1A),
          //     getFontFamily: AppConfig().outfitFontRegular,
          //     getTextDirection:
          //         LanguageTextFile().getTextDirection(getLanguageCode),
          //     getSoftWrap: true),
          Text(
            buttonText,
            textScaler: const TextScaler.linear(1.0),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: screenHeight *
                    (AppConfig().primaryButtonTextSize /
                        AppConfig().screenHeight),
                color: const Color(0xFFAB2E1A),
                fontFamily: AppConfig().outfitFontRegular),
            textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
          ),
          iconPath != null
              ? SizedBox(
                  width: screenWidth * (10 / AppConfig().screenWidth),
                )
              : const SizedBox(),
          iconPath != null
              ? SvgPicture.asset(
                  iconPath,
                  width: screenWidth * (iconWidth! / AppConfig().screenWidth),
                  height:
                      screenHeight * (iconHeight! / AppConfig().screenHeight),
                  fit: BoxFit.scaleDown,
                  color: getDarkMode
                      ? const Color(0xFFDB7F5E)
                      : const Color(0xFF9A3524),
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}
