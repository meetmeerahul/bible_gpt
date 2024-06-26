import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../config/app_config.dart';
import '../config/language_text_file.dart';
import 'textWidget.dart';

Widget MenuBarSettingWidget({
  required BuildContext context,
  required double screenWidth,
  required double screenHeight,
  required bool getDarkMode,
  required String getLanguageCode,
  required List<String> getLanguageList,
  required bool isDeleteAPILoading,
  required bool isUserLoggedIn,
  required bool switchValue,
  required Function(int) settingSelectedClick,
  required Function(String) languageSelectedClick,
}) {
  return Container(
    width: screenWidth * (346 / AppConfig().screenWidth),
    padding: EdgeInsets.symmetric(
        horizontal: screenWidth * (16 / AppConfig().screenWidth)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight * (24 / AppConfig().screenHeight),
        ),
        Container(
          child: Text(
            LanguageTextFile().getLanguageSettingTitleText(getLanguageCode),
            textScaler: const TextScaler.linear(1.0),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: MediaQuery.of(context)
                  .textScaler
                  .scale((screenHeight * (18 / AppConfig().screenHeight))),
              color: getDarkMode
                  ? const Color(0xFFFBE4AB)
                  : const Color(0xFFA36501),
              fontFamily: AppConfig().outfitFontRegular,
            ),
            textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
          ),
        ),
        SizedBox(
          height: screenHeight * (10 / AppConfig().screenHeight),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              print("Language Setting");
              LanguageDialogBox(
                  context: context,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  darkMode: getDarkMode,
                  getLanguageCode: getLanguageCode,
                  getLanguageList: getLanguageList,
                  getCallBackLanguageChange: (String getSelectedLanguage) {
                    languageSelectedClick(getSelectedLanguage);
                  });
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
                Container(
                  child: Row(
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          LanguageTextFile()
                              .getLanguageSettingLanguageChangeText(
                                  getLanguageCode),
                          textScaler: const TextScaler.linear(1.0),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaler.scale(
                                  (screenHeight *
                                      (14 / AppConfig().screenHeight))),
                              color: getDarkMode
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF8A8A8A),
                              fontFamily: AppConfig().outfitFontRegular),
                          textDirection: LanguageTextFile()
                              .getTextDirection(getLanguageCode),
                        ),
                      ),
                      Container(
                        child: Row(
                          textDirection: LanguageTextFile()
                              .getTextDirection(getLanguageCode),
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: TextWidget(
                                  context: context,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  getText: LanguageTextFile()
                                      .getLanguageName(getLanguageCode),
                                  fontSize: 12,
                                  getTextAlign: TextAlign.start,
                                  getTextColor: getDarkMode
                                      ? const Color(0xFF999999)
                                      : const Color(0xFF999999),
                                  getFontFamily: AppConfig().outfitFontRegular,
                                  getTextDirection: LanguageTextFile()
                                      .getTextDirection(getLanguageCode),
                                  getSoftWrap: true),
                            ),
                            SizedBox(
                              width: screenWidth *
                                  (AppConfig()
                                          .settingScreenPaddingBetweenTextAndDropDown /
                                      AppConfig().screenWidth),
                            ),
                            SizedBox(
                              width: screenWidth *
                                  (AppConfig().settingScreenDropDownWidth /
                                      AppConfig().screenWidth),
                              child: SvgPicture.asset(
                                height: (screenHeight *
                                    (7 / AppConfig().screenHeight)),
                                width: (screenWidth *
                                    (7 / AppConfig().screenWidth)),
                                AppConfig().getDropDownIcon,
                                fit: BoxFit.fitWidth,
                                color: getDarkMode
                                    ? AppConfig()
                                        .settingScreenDropdownArrowDarkColor
                                    : AppConfig()
                                        .settingScreenDropdownArrowLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (10 / AppConfig().screenHeight),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              print("Dark Mode");
              settingSelectedClick(2);
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
                Container(
                  child: Row(
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LanguageTextFile()
                              .getLanguageSettingDarkModeText(getLanguageCode),
                          textScaler: const TextScaler.linear(1.0),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaler.scale(
                                  (screenHeight *
                                      (14 / AppConfig().screenHeight))),
                              color: getDarkMode
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF8A8A8A),
                              fontFamily: AppConfig().outfitFontRegular),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0xFFDB7F5E),
                              Color(0xFFDB7F5E),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                          border: Border.all(
                              color: const Color(0xFFDB7F5E),
                              width: screenWidth *
                                  (AppConfig()
                                          .primaryButtonOuterBorderLineHeight /
                                      AppConfig().screenWidth)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              screenHeight *
                                  (AppConfig().settingScreenSwitchButtonHeight /
                                      AppConfig().screenHeight),
                            ),
                          ),
                        ),
                        width: screenWidth *
                            (AppConfig().settingScreenSwitchButtonWidth /
                                AppConfig().screenWidth),
                        height: screenHeight *
                            (AppConfig().settingScreenSwitchButtonHeight /
                                AppConfig().screenHeight),
                        child: FlutterSwitch(
                          width: screenWidth *
                              (AppConfig().settingScreenSwitchButtonWidth /
                                  AppConfig().screenWidth),
                          height: screenHeight *
                              (AppConfig().settingScreenSwitchButtonHeight /
                                  AppConfig().screenHeight),
                          valueFontSize: 0,
                          toggleSize: screenHeight *
                              (AppConfig()
                                      .settingScreenSwitchButtonInnerHeight /
                                  AppConfig().screenHeight),
                          value: switchValue,
                          activeColor: Colors.transparent,
                          inactiveColor: Colors.transparent,
                          toggleColor: switchValue
                              ? AppConfig().settingScreenInnerSwitchDarkColor
                              : AppConfig().settingScreenInnerSwitchLightColor,
                          borderRadius: screenHeight *
                              (AppConfig().settingScreenSwitchButtonHeight /
                                  AppConfig().screenHeight),
                          padding: screenWidth *
                              (AppConfig().settingScreenSwitchPadding /
                                  AppConfig().screenWidth),
                          showOnOff: true,
                          onToggle: (val) {
                            settingSelectedClick(2);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (10 / AppConfig().screenHeight),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              print("Privacy Policy");
              settingSelectedClick(3);
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
                Container(
                  child: Row(
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LanguageTextFile().getLanguageSettingTermPrivacyText(
                              getLanguageCode),
                          textScaler: const TextScaler.linear(1.0),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaler.scale(
                                  (screenHeight *
                                      (14 / AppConfig().screenHeight))),
                              color: getDarkMode
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF8A8A8A),
                              fontFamily: AppConfig().outfitFontRegular),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (10 / AppConfig().screenHeight),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              print("Contact Us");
              settingSelectedClick(4);
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
                Container(
                  child: Row(
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LanguageTextFile()
                              .getLanguageSettingContactText(getLanguageCode),
                          textScaler: const TextScaler.linear(1.0),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaler.scale(
                                  (screenHeight *
                                      (14 / AppConfig().screenHeight))),
                              color: getDarkMode
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF8A8A8A),
                              fontFamily: AppConfig().outfitFontRegular),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (10 / AppConfig().screenHeight),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: () {
              print("Rating Us");
              settingSelectedClick(5);
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
                Container(
                  child: Row(
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LanguageTextFile()
                              .getLanguageSettingRateUsText(getLanguageCode),
                          textScaler: const TextScaler.linear(1.0),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaler.scale(
                                  (screenHeight *
                                      (14 / AppConfig().screenHeight))),
                              color: getDarkMode
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF8A8A8A),
                              fontFamily: AppConfig().outfitFontRegular),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (10 / AppConfig().screenHeight),
                ),
              ],
            ),
          ),
        ),
        isUserLoggedIn
            ? Container(
                child: TextButton(
                  onPressed: () {
                    print("Delete Account");
                    settingSelectedClick(6);
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
                      Text(
                        LanguageTextFile()
                            .getLanguageSettingDeleteAccountText(getLanguageCode),
                        textScaler: const TextScaler.linear(1.0),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaler.scale(
                                (screenHeight *
                                    (14 / AppConfig().screenHeight))),
                            color: getDarkMode
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF8A8A8A),
                            fontFamily: AppConfig().outfitFontRegular),
                      ),
                      SizedBox(
                        height: screenHeight * (10 / AppConfig().screenHeight),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    ),
  );
}

LanguageDialogBox(
    {required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required bool darkMode,
    required String getLanguageCode,
    required List<String> getLanguageList,
    required Function(String) getCallBackLanguageChange}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
          return Dialog(
            alignment: Alignment.center,
            insetPadding: const EdgeInsets.all(0),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth *
                    (AppConfig().settingScreenAlertDialogBoxRadius /
                        AppConfig().screenWidth))), //this right here
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: screenWidth *
                      ((AppConfig().settingScreenAlertDialogBoxInnerPadding +
                              AppConfig()
                                  .settingScreenAlertDialogBoxInnerPadding +
                              AppConfig().settingScreenAlertRadioButtonWidth +
                              AppConfig()
                                  .settingScreenAlertDialogBoxPaddingBetweenRadioText +
                              AppConfig().settingScreenAlertTextWidth) /
                          AppConfig().screenWidth),
                  decoration: BoxDecoration(
                    color: darkMode
                        ? AppConfig().settingScreenAlertBackgroundDarkColor
                        : AppConfig().settingScreenAlertBackgroundLightColor,
                    borderRadius: BorderRadius.circular(screenWidth *
                        (AppConfig().settingScreenAlertDialogBoxRadius /
                            AppConfig().screenWidth)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth *
                        (AppConfig().settingScreenAlertDialogBoxInnerPadding /
                            AppConfig().screenWidth)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: TextButton(
                            onPressed: () {
                              getCallBackLanguageChange(getLanguageList[0]);
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              textDirection: LanguageTextFile()
                                  .getTextDirection(getLanguageCode),
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: screenWidth *
                                      (AppConfig()
                                              .settingScreenAlertRadioButtonWidth /
                                          AppConfig().screenWidth),
                                  height: screenWidth *
                                      (AppConfig()
                                              .settingScreenAlertRadioButtonWidth /
                                          AppConfig().screenWidth),
                                  child: Radio(
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                        return (getLanguageCode ==
                                                getLanguageList[0])
                                            ? AppConfig()
                                                .settingScreenAlertRadioActiveColor
                                            : darkMode
                                                ? AppConfig()
                                                    .settingScreenAlertRadioInActiveDarkColor
                                                : AppConfig()
                                                    .settingScreenAlertRadioInActiveLightColor;
                                      }),
                                      value: getLanguageList[0],
                                      groupValue: getLanguageCode,
                                      onChanged: (value) {
                                        getCallBackLanguageChange(
                                            getLanguageList[0]);
                                        Navigator.pop(context);
                                      }),
                                ),
                                SizedBox(
                                  width: screenWidth *
                                      (AppConfig()
                                              .settingScreenAlertDialogBoxPaddingBetweenRadioText /
                                          AppConfig().screenWidth),
                                ),
                                Container(
                                  child: TextWidget(
                                      context: context,
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      getText: LanguageTextFile()
                                          .getLanguageName(getLanguageList[0]),
                                      fontSize: AppConfig()
                                          .settingScreenAlertTextSize,
                                      getTextAlign: TextAlign.start,
                                      getTextColor: darkMode
                                          ? AppConfig()
                                              .settingScreenAlertTextDarkColor
                                          : AppConfig()
                                              .settingScreenAlertTextLightColor,
                                      getFontFamily:
                                          AppConfig().outfitFontRegular,
                                      getTextDirection: TextDirection.ltr,
                                      getSoftWrap: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight *
                              (AppConfig()
                                      .settingScreenAlertDialogBetweenLanguage /
                                  AppConfig().screenHeight),
                        ),
                        Container(
                          child: TextButton(
                            onPressed: () {
                              getCallBackLanguageChange(getLanguageList[1]);
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              textDirection: LanguageTextFile()
                                  .getTextDirection(getLanguageCode),
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: screenWidth *
                                      (AppConfig()
                                              .settingScreenAlertRadioButtonWidth /
                                          AppConfig().screenWidth),
                                  height: screenWidth *
                                      (AppConfig()
                                              .settingScreenAlertRadioButtonWidth /
                                          AppConfig().screenWidth),
                                  child: Radio(
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                        return (getLanguageCode ==
                                                getLanguageList[1])
                                            ? AppConfig()
                                                .settingScreenAlertRadioActiveColor
                                            : darkMode
                                                ? AppConfig()
                                                    .settingScreenAlertRadioInActiveDarkColor
                                                : AppConfig()
                                                    .settingScreenAlertRadioInActiveLightColor;
                                      }),
                                      value: getLanguageList[1],
                                      groupValue: getLanguageCode,
                                      onChanged: (value) {
                                        getCallBackLanguageChange(
                                            getLanguageList[1]);
                                        Navigator.pop(context);
                                      }),
                                ),
                                SizedBox(
                                  width: screenWidth *
                                      (AppConfig()
                                              .settingScreenAlertDialogBoxPaddingBetweenRadioText /
                                          AppConfig().screenWidth),
                                ),
                                Container(
                                  child: TextWidget(
                                      context: context,
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      getText: LanguageTextFile()
                                          .getLanguageName(getLanguageList[1]),
                                      fontSize: AppConfig()
                                          .settingScreenAlertTextSize,
                                      getTextAlign: TextAlign.start,
                                      getTextColor: darkMode
                                          ? AppConfig()
                                              .settingScreenAlertTextDarkColor
                                          : AppConfig()
                                              .settingScreenAlertTextLightColor,
                                      getFontFamily:
                                          AppConfig().outfitFontRegular,
                                      getTextDirection: TextDirection.ltr,
                                      getSoftWrap: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight *
                              (AppConfig()
                                      .settingScreenAlertDialogBoxBottomPadding /
                                  AppConfig().screenHeight),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      });
}
