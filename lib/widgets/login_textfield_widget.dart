

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/app_config.dart';
import '../config/language_text_file.dart';



Widget LogInTextFieldWidget(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    double scaleFactor,
    double widgetWidth,
    double widgetHeight,
    TextEditingController textEditingController,
    bool isPassword,
    bool showPassword,
    String hintText,
    TextInputAction getTextAction,
    TextInputType getKeyboardType,
    bool darkMode,
    String getLanguageCode,
    bool readMode,
    Function(String) getTextFunction,
    Function(bool) passwordVisibleFunction) {
  return Container(
    width: screenWidth * (widgetWidth / AppConfig().screenWidth),
    height: screenHeight * (widgetHeight / AppConfig().screenHeight),
    child: TextFormField(
      //maxLength: getKeyboardType==TextInputType.number?10:null,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      obscureText: isPassword ? showPassword : false,
      cursorColor: darkMode
          ? AppConfig().logInEdittextLineBorderDarkColor
          : AppConfig().logInEdittextLineBorderLightColor,
      controller: textEditingController,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: getTextAction,
      textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
      keyboardType: getKeyboardType,
      readOnly: readMode,
      inputFormatters: getKeyboardType == TextInputType.number
          ? [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ]
          : getKeyboardType == TextInputType.name
              ? [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                ]
              : null,
      onChanged: (text) {
        getTextFunction(text);
      },
      decoration: InputDecoration(
        hintTextDirection: LanguageTextFile().getTextDirection(getLanguageCode),
        counterText: "",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: darkMode
                  ? AppConfig().logInEdittextLineBorderDarkColor
                  : AppConfig().logInEdittextLineBorderLightColor,
              width: screenHeight *
                  (AppConfig().logInWidgetLineBorderHeight /
                      AppConfig().screenHeight)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: darkMode
                  ? AppConfig().logInEdittextLineBorderDarkColor
                  : AppConfig().logInEdittextLineBorderLightColor,
              width: screenHeight *
                  (AppConfig().logInWidgetLineBorderHeight /
                      AppConfig().screenHeight)),
        ),
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: screenHeight *
                (AppConfig().logInEdittextHintTextSize /
                    (AppConfig().screenHeight * scaleFactor)),
            color: darkMode
                ? AppConfig().logInEdittextTextDarkColor
                : AppConfig().logInEdittextTextLightColor,
            fontFamily: AppConfig().outfitFontRegular),
        suffixIconConstraints: BoxConstraints.expand(
          
            width: screenHeight *
                ((AppConfig().logInWidgetIconHeight +
                        AppConfig().logInEdittextLeftPadding +
                        AppConfig().logInEdittextLeftPadding) /
                    AppConfig().screenHeight),
            height: (screenHeight *
                (AppConfig().logInWidgetIconHeight /
                    AppConfig().screenHeight))),
        suffixIcon: isPassword
            ? TextButton(
                onPressed: () {
                  print("Click");
                  if (showPassword) {
                    passwordVisibleFunction(false);
                  } else {
                    passwordVisibleFunction(true);
                  }
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth *
                          (AppConfig().logInEdittextLeftPadding /
                              AppConfig().screenWidth)),
                  child: Container(
                    //width: screenHeight*(AppConfig().logInWidgetIconHeight/AppConfig().screenHeight),
                    height: screenHeight *
                        (AppConfig().logInWidgetIconHeight /
                            AppConfig().screenHeight),
                    child: SvgPicture.asset(
                      showPassword
                          ? AppConfig().logInWidgetUnHidePasswordIcon
                          : AppConfig().logInWidgetHidePasswordIcon,
                      fit: BoxFit.fitHeight,
                      color: darkMode
                          ? AppConfig().logInEdittextIconDarkColor
                          : AppConfig().logInEdittextIconLightColor,
                    ),
                  ),
                ),
              )
            : null,
      ),
      style: TextStyle(
          fontSize: screenHeight *
              (AppConfig().logInEdittextTextSize /
                  (AppConfig().screenHeight * scaleFactor)),
          color: darkMode
              ? AppConfig().logInEdittextTextDarkColor
              : AppConfig().logInEdittextTextLightColor,
          fontFamily: AppConfig().outfitFontRegular),
    ),
  );
}
