import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/app_config.dart';
import '../../config/language_text_file.dart';

ElevatedButton GoogleButton(
    {required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required double buttonWidth,
    required double buttonHeight,
    required String buttonText,
    required String getLanguageCode,
    required bool isAPILoading,
    required Function(bool) buttonPressedFunction}) {
  return ElevatedButton(
    onPressed: () {
      buttonPressedFunction(true);
    },
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      foregroundColor: Colors.black,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: Size(
        screenWidth * (buttonWidth / AppConfig().screenWidth),
        screenHeight * (buttonHeight / AppConfig().screenHeight),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(
            screenHeight * (buttonHeight / AppConfig().screenHeight))),
      ),
    ),
    child: Container(
      padding: EdgeInsets.zero,
      width: screenWidth * (buttonWidth / AppConfig().screenWidth),
      height: screenHeight * (buttonHeight / AppConfig().screenHeight),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(
            screenHeight * (buttonHeight / AppConfig().screenHeight))),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
        children: [
          SizedBox(
            width: screenHeight * (24 / AppConfig().screenHeight),
            height: screenHeight * (24 / AppConfig().screenHeight),
            child: SvgPicture.asset(
              AppConfig().signInScreenGoogleIcon,
              fit: BoxFit.scaleDown,
            ),
          ),
          SizedBox(
            width: screenWidth * (15 / AppConfig().screenWidth),
          ),
          Flexible(
            // child: languageFutureWidget(
            //     screenWidth: screenWidth,
            //     screenHeight: screenHeight,
            //     selectedLanguage: getLanguageCode,
            //     getLanguageTranslatorMethod: buttonTextFunction,
            //     getFontSize: AppConfig().primaryButtonTextSize,
            //     getDarkMode: false,
            //     getTextAlign: TextAlign.start,
            //     getTextColor: Color(0xFF000000).withOpacity(0.54),
            //     getFontFamily: AppConfig().outfitFontMedium,
            //     getTextDirection:
            //         LanguageTextFile().getTextDirection(getLanguageCode),
            //     getSoftWrap: true),
            child: Text(
              buttonText,
              textScaler: const TextScaler.linear(1.0),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: screenHeight *
                      (AppConfig().primaryButtonTextSize /
                          AppConfig().screenHeight),
                  color: const Color(0xFF000000).withOpacity(0.54),
                  fontFamily: AppConfig().outfitFontMedium),
              textDirection:
                  LanguageTextFile().getTextDirection(getLanguageCode),
            ),
          ),
        ],
      ),
    ),
  );
}
