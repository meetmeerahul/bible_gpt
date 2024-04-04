import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/app_config.dart';
import '../../config/language_text_file.dart';

ElevatedButton PrimaryButton(
    {required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required double buttonWidth,
    required double buttonHeight,
    required bool getDarkMode,
    required String buttonText,
    required String getLanguageCode,
    required bool isAPILoading,
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
      foregroundColor: Colors.black,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: Size(
        screenWidth * (buttonWidth / AppConfig().screenWidth),
        screenHeight * (buttonHeight / AppConfig().screenHeight),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(screenHeight *
            (AppConfig().primaryButtonCurveSize / AppConfig().screenHeight))),
      ),
    ),
    child: Container(
      padding: EdgeInsets.zero,
      width: screenWidth * (buttonWidth / AppConfig().screenWidth),
      height: screenHeight * (buttonHeight / AppConfig().screenHeight),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            getDarkMode
                ? AppConfig().primaryButtonOuterBorderDarkGradiantStartColor
                : AppConfig().primaryButtonOuterBorderGradiantStartColor,
            getDarkMode
                ? AppConfig().primaryButtonOuterBorderDarkGradiantEndColor
                : AppConfig().primaryButtonOuterBorderGradiantEndColor,
          ],
          tileMode: TileMode.mirror,
        ),
        // border: Border.all(
        //     color: getDarkMode
        //         ? AppConfig().primaryButtonOuterBorderDarkLineColor
        //         : AppConfig().primaryButtonOuterBorderLineColor,
        //     width: screenWidth *
        //         (AppConfig().primaryButtonOuterBorderLineHeight /
        //             AppConfig().screenWidth)),
        borderRadius: BorderRadius.all(Radius.circular(screenHeight *
            (AppConfig().primaryButtonCurveSize / AppConfig().screenHeight))),
      ),
      alignment: Alignment.center,
      child: isAPILoading
          ? Container(
              width: screenHeight *
                  (AppConfig().primaryButtonTextSize *
                      1.5 /
                      AppConfig().screenHeight),
              height: screenHeight *
                  (AppConfig().primaryButtonTextSize *
                      1.5 /
                      AppConfig().screenHeight),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppConfig().primaryButtonTextColor,
                strokeWidth: screenWidth * (2 / AppConfig().screenWidth),
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            )
          : Row(
              textDirection:
                  LanguageTextFile().getTextDirection(getLanguageCode),
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconPath != null
                    ? SvgPicture.asset(
                        iconPath,
                        width: screenWidth *
                            (iconWidth! / AppConfig().screenWidth),
                        height: screenHeight *
                            (iconHeight! / AppConfig().screenHeight),
                        fit: BoxFit.scaleDown,
                      )
                    : const SizedBox(),
                iconPath != null
                    ? SizedBox(
                        width: screenWidth * (10 / AppConfig().screenWidth),
                      )
                    : const SizedBox(),
                Flexible(
                  child: Text(
                    buttonText,
                    textScaler: const TextScaler.linear(1.0),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaler.scale(
                            screenHeight *
                                (AppConfig().primaryButtonTextSize /
                                    AppConfig().screenHeight)),
                        color: AppConfig().primaryButtonTextColor,
                        fontFamily: AppConfig().outfitFontRegular),
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                  ),
                  /*   child: languageFutureWidget(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      selectedLanguage: getLanguageCode,
                      getLanguageTranslatorMethod: buttonTextFunction,
                      getFontSize: AppConfig().primaryButtonTextSize,
                      getDarkMode: false,
                      getTextAlign: TextAlign.center,
                      getTextColor: AppConfig().primaryButtonTextColor,
                      getFontFamily: AppConfig().outfitFontRegular,
                      getTextDirection:
                          LanguageTextFile().getTextDirection(getLanguageCode),
                      getSoftWrap: true), */
                ),
              ],
            ),
    ),
  );
}
