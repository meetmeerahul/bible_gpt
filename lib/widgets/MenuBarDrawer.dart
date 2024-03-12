import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/app_config.dart';
import '../signInScreen/signinScreen.dart';
import 'MenuBarCategoryWidget.dart';
import 'MenuBarProfileWidget.dart';
import 'MenuBarSettingWidget.dart';
import 'MenuBarSocialMediaWidget.dart';

Drawer MenuBarDrawer({
  required BuildContext context,
  required double screenWidth,
  required double screenHeight,
  required double statusBarHeight,
  required bool getDarkMode,
  required String getLanguageCode,
  required String profilePictureUrl,
  required int currentCategory,
  required List<String> getLanguageList,
  required bool isDeleteAPILoading,
  required bool isUserLoggedIn,
  required bool switchValue,
  required String chapterText,
  required String profileName,
  required Function(bool) callBackProfileClickFunction,
  required Function(int) callBackSocialMediaFunction,
  required Function(int) callBackSelectedCategory,
  required Function(int) callBackSettingSelected,
  required Function(String) callBackLanguageSelectedClick,
}) {
  return Drawer(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0))),
    width: screenWidth * (346 / AppConfig().screenWidth),
    child: SizedBox(
      width: screenWidth * (346 / AppConfig().screenWidth),
      height: screenHeight,
      child: Stack(
        children: [
          SizedBox(
            width: screenWidth * (346 / AppConfig().screenWidth),
            height: screenHeight,
            child: SvgPicture.asset(
              getDarkMode
                  ? AppConfig().darkBackgroundColor
                  : AppConfig().backgroundColor,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: screenWidth * (346 / AppConfig().screenWidth),
            height: screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight *
                      (statusBarHeight / AppConfig().screenHeight),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SigninScreen())),
                  child: MenuBarProfileWidget(
                      context: context,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      darkMode: getDarkMode,
                      profilePictureUrl: profilePictureUrl,
                      profileName: profileName,
                      getLanguageCode: getLanguageCode,
                      profileClick: (isClick) {
                        if (isClick) {
                          callBackProfileClickFunction(true);
                        }
                      }),
                ),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width:
                                screenWidth * (346 / AppConfig().screenWidth),
                            height:
                                screenHeight * (0.3 / AppConfig().screenHeight),
                            color: const Color(0xFFDB7F5E),
                          ),
                          MenuBarCategoryWidget(
                              context: context,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              getDarkMode: getDarkMode,
                              getLanguageCode: getLanguageCode,
                              currentCategory: currentCategory,
                              chapterText: chapterText,
                              selectedCategoryFunction:
                                  (int getSelectedCategory) {
                                callBackSelectedCategory(getSelectedCategory);
                              }),
                          Container(
                            width:
                                screenWidth * (346 / AppConfig().screenWidth),
                            height:
                                screenHeight * (0.3 / AppConfig().screenHeight),
                            color: const Color(0xFFDB7F5E),
                          ),
                          MenuBarSettingWidget(
                            context: context,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            getDarkMode: getDarkMode,
                            getLanguageCode: getLanguageCode,
                            getLanguageList: getLanguageList,
                            isDeleteAPILoading: isDeleteAPILoading,
                            isUserLoggedIn: isUserLoggedIn,
                            switchValue: switchValue,
                            settingSelectedClick: (int getSelectedClick) {
                              callBackSettingSelected(getSelectedClick);
                            },
                            languageSelectedClick: (String selectedLanguage) {
                              callBackLanguageSelectedClick(selectedLanguage);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MenuBarSocialMediaWidget(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    darkMode: getDarkMode,
                    getSelectedSocialMediaFunction: (getSelectedSocialMedia) {
                      callBackSocialMediaFunction(getSelectedSocialMedia);
                    })
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
