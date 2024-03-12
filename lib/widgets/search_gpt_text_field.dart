import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/app_config.dart';
import '../config/language_text_file.dart';

Widget SearchGptTextFieldWidget({
  required double screenWidth,
  required double screenHeight,
  required double scaleFactor,
  required String getHintText,
  required bool readOnly,
  required TextEditingController? textEditingController,
  required bool isListening,
  required bool darkMode,
  required double backgroundOpacity,
  required String getLanguageCode,
  required ScrollController? textScrollController,
  required Function(String) getEdittextFunction,
  required Function(String) submitTextFunction,
  required Function(bool) getListeningFunction,
}) {
  return GestureDetector(
    onTap: () {
      getListeningFunction(isListening);
    },
    child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth *
              (AppConfig().searchGptWidgetLeftPadding /
                  AppConfig().screenWidth),
        ),
        child: Stack(
          textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
          alignment: Alignment.center,
          children: [
            Container(
              width: screenWidth - screenWidth * (48 / AppConfig().screenWidth),
              height: screenWidth *
                  (AppConfig().searchGptWidgetEnterOuterButtonIconWidth /
                      AppConfig().screenWidth),
              decoration: BoxDecoration(
                color: darkMode
                    ? AppConfig()
                        .searchGptWidgetEdittextOuterBackgroundDarkColor
                    : AppConfig()
                        .searchGptWidgetEdittextOuterBackgroundLightColor,
                border: Border.all(
                    width: screenWidth *
                        (AppConfig().searchGptWidgetEdittextBorderHeight /
                            AppConfig().screenHeight),
                    color: darkMode
                        ? AppConfig()
                            .searchGptWidgetEdittextOuterBorderLineDarkColor
                        : AppConfig()
                            .searchGptWidgetEdittextOuterBorderLineLightColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    screenWidth *
                        (AppConfig().searchGptWidgetEnterOuterButtonIconWidth /
                            AppConfig().screenWidth),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    //color: Color(0xFFA36501),
                    color: const Color(0xff00000080).withOpacity(0.25),
                    blurRadius: 1,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: AppConfig().testmentBoxTop / 5.5),
                child: TextFormField(
                  scrollController: textScrollController,
                  textDirection:
                      LanguageTextFile().getTextDirection(getLanguageCode),
                  readOnly: readOnly,
                  controller: textEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  onTap: () {
                    if (readOnly) {
                      submitTextFunction("");
                    }
                  },
                  onChanged: (getText) {
                    if (!readOnly) {
                      getEdittextFunction(getText);
                    }
                  },
                  decoration: InputDecoration(
                    hintTextDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                    border: InputBorder.none,
                    //contentPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.only(
                        left: screenWidth *
                            (AppConfig()
                                    .searchGptWidgetEdittextInnerHorizontalPadding /
                                AppConfig().screenWidth),
                        right: screenWidth *
                            ((AppConfig()
                                        .searchGptWidgetEnterOuterButtonIconWidth +
                                    AppConfig()
                                        .searchGptWidgetEnterOuterButtonIconWidth) /
                                AppConfig().screenWidth),
                        top: (((screenWidth *
                                    (AppConfig()
                                            .searchGptWidgetEnterOuterButtonIconWidth /
                                        AppConfig().screenWidth)) /
                                2) -
                            screenHeight *
                                (AppConfig().searchGptWidgetEdittextTextSize /
                                    (AppConfig().screenHeight *
                                        scaleFactor)))), // add padding to adjust text
                    isDense: true,
                    //filled: true,
                    hintText: getHintText,
                    hintStyle: TextStyle(
                        fontSize: screenHeight *
                            (AppConfig().searchGptWidgetEdittextHintTextSize /
                                (AppConfig().screenHeight * scaleFactor)),
                        color: darkMode
                            ? AppConfig().searchGptWidgetEdittextTextDarkColor
                            : AppConfig().searchGptWidgetEdittextTextLightColor,
                        fontFamily: AppConfig().outfitFontRegular),
                  ),
                  style: TextStyle(
                      fontSize: screenHeight *
                          (AppConfig().searchGptWidgetEdittextTextSize /
                              (AppConfig().screenHeight * scaleFactor)),
                      color: darkMode
                          ? AppConfig().searchGptWidgetEdittextTextDarkColor
                          : AppConfig().searchGptWidgetEdittextTextLightColor,
                      fontFamily: AppConfig().outfitFontRegular),
                ),
              ),
            ),
            Container(
              width: screenWidth *
                  (AppConfig().searchGptWidgetEdittextWidth /
                      AppConfig().screenWidth),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(
                  right: screenWidth * (2 / AppConfig().screenWidth)),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () {
                          getListeningFunction(true);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Container(
                          width: screenWidth *
                              (AppConfig()
                                      .searchGptWidgetEnterOuterButtonIconWidth /
                                  AppConfig().screenWidth),
                          height: screenWidth *
                              (AppConfig()
                                      .searchGptWidgetEnterOuterButtonIconWidth /
                                  AppConfig().screenWidth),
                          alignment: Alignment.center,
                          child: textEditingController!.text.isNotEmpty
                              ? SizedBox(
                                  width: screenWidth *
                                      (AppConfig()
                                              .searchGptWidgetEdittextIconWidth /
                                          AppConfig().screenWidth),
                                  height: screenWidth *
                                      (AppConfig()
                                              .searchGptWidgetEdittextIconWidth /
                                          AppConfig().screenWidth),
                                  child: SvgPicture.asset(
                                    AppConfig().searchGptWidgetCrossMarkIcon,
                                    fit: BoxFit.scaleDown,
                                    color: darkMode
                                        ? AppConfig().searchGptMicIconDarkColor
                                        : AppConfig()
                                            .searchGptMicIconLightColor,
                                  ),
                                )
                              : SizedBox(
                                  width: screenWidth *
                                      (AppConfig()
                                              .searchGptWidgetEnterOuterButtonIconWidth /
                                          AppConfig().screenWidth),
                                  height: screenWidth *
                                      (AppConfig()
                                              .searchGptWidgetEnterOuterButtonIconWidth /
                                          AppConfig().screenWidth),
                                  child: AvatarGlow(
                                    animate: isListening ? true : false,
                                    glowColor: darkMode
                                        ? AppConfig().searchGptMicIconDarkColor
                                        : AppConfig()
                                            .searchGptMicIconLightColor,
                                    endRadius: screenWidth *
                                        (AppConfig()
                                                .searchGptWidgetEnterOuterButtonIconWidth /
                                            AppConfig().screenWidth),
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    repeatPauseDuration:
                                        const Duration(milliseconds: 100),
                                    repeat: true,
                                    child: SizedBox(
                                      width: screenWidth *
                                          (AppConfig()
                                                  .searchGptWidgetEdittextIconWidth /
                                              AppConfig().screenWidth),
                                      height: screenWidth *
                                          (AppConfig()
                                                  .searchGptWidgetEdittextIconWidth /
                                              AppConfig().screenWidth),
                                      child: SvgPicture.asset(
                                        AppConfig().searchGptWidgetMicOnIcon,
                                        fit: BoxFit.scaleDown,
                                        color: darkMode
                                            ? AppConfig()
                                                .searchGptMicIconDarkColor
                                            : AppConfig()
                                                .searchGptMicIconLightColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          submitTextFunction(textEditingController.text);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Container(
                          width: screenWidth *
                              ((AppConfig()
                                          .searchGptWidgetEnterOuterButtonIconWidth -
                                      4) /
                                  AppConfig().screenWidth),
                          height: screenWidth *
                              ((AppConfig()
                                          .searchGptWidgetEnterOuterButtonIconWidth -
                                      4) /
                                  AppConfig().screenWidth),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                AppConfig()
                                    .searchGptEnterBackgroundStartLightColor,
                                AppConfig()
                                    .searchGptEnterBackgroundEndLightColor,
                              ],
                              tileMode: TileMode.mirror,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                screenWidth *
                                    ((AppConfig()
                                                .searchGptWidgetEnterOuterButtonIconWidth -
                                            4) /
                                        AppConfig().screenWidth),
                              ),
                            ),
                            //color: darkMode?AppConfig().searchGptEnterBackgroundDarkColor:AppConfig().searchGptEnterBackgroundLightColor,
                          ),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: screenWidth *
                                (AppConfig().searchGptWidgetEdittextIconWidth /
                                    AppConfig().screenWidth),
                            height: screenWidth *
                                (AppConfig().searchGptWidgetEdittextIconWidth /
                                    AppConfig().screenWidth),
                            child: SvgPicture.asset(
                              AppConfig().categoryDetailScreenSearchIcon,
                              fit: BoxFit.scaleDown,
                              color: darkMode
                                  ? AppConfig().searchGptEnterIconDarkColor
                                  : AppConfig().searchGptEnterIconLightColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
  );
}
