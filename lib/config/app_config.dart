import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  //App
  double screenWidth = 428;
  double screenHeight = 926;

  String backgroundColor = "assets/svg/background_color.svg";
  String darkBackgroundColor = "assets/svg/dark_background_color.svg";
  String cardBackgroundColor = "assets/svg/card_background_color.svg";
  String darkCardBackgroundColor = "assets/svg/dark_card_background_color.svg";
  String chapterCardIcon = "assets/svg/chapter_card_icon.svg";
  String cardLotusIcon = "assets/png/lotus_icon.png";
  String darkCardLotusIcon = "assets/png/dark_lotus_icon.png";
  String summaryCloseIcon = "assets/svg/summary_close_icon.svg";
  String summaryBackgroundIcon = "assets/png/summary_background_icon.png";

  var shimmerGradient = const LinearGradient(
    colors: [
      /*Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),*/
      Colors.grey,
      Colors.white,
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  //StatusBar

  getStatusBar(bool getDarkMode) {
    return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: getDarkMode ? Brightness.light : Brightness.dark,
    ));
  }

  //Font Style
  String outfitFontBold = "OutfitBold";
  String outfitFontSemiBold = "OutfitSemiBold";
  String outfitFontMedium = "OutfitMedium";
  String outfitFontRegular = "OutfitRegular";

  //Reusable Components
  //Background App Image
  double appBackgroundLogoWidth = 428;
  double appBackgroundLogoHeight = 318;
  String appBackgroundLightLogo = "assets/svg/background_logo.svg";
  String appBackgroundDarkLogo = "assets/svg/dark_background_logo.svg";

  //Back Arrow
  //Image
  String backArrowWidgetIcon = "assets/svg/back_arrow.svg";

  //Size
  double backArrowWidgetOuterWidth = 32;
  double backArrowWidgetOuterHeight = 32;
  double backArrowWidgetSizeWidth = 32;
  double backArrowWidgetSizeHeight = 32;

  //Color
  Color backArrowLightColor = const Color(0xFF000000);
  Color backArrowDarkColor = const Color(0xFFFFFFFF);

  //Padding
  double backArrowWidgetLeftPadding = 16;

  //Primary Button
  //Color

  Color primaryButtonOuterBorderLineColor = const Color(0xFFC7882B);
  Color primaryButtonOuterBorderGradiantStartColor = const Color(0xFFC57908);
  Color primaryButtonOuterBorderGradiantEndColor = const Color(0xFF643502);
  Color primaryButtonOuterBorderDarkLineColor = const Color(0xFFC57907);
  Color primaryButtonOuterBorderDarkGradiantStartColor =
      const Color(0xFFC57907);
  Color primaryButtonOuterBorderDarkGradiantEndColor = const Color(0xFF623301);
  Color primaryButtonTextColor = const Color(0xFFFFFFFF);

  //Size
  double primaryButtonTextSize = 16;
  double primaryButtonCurveSize = 30;
  double primaryButtonOuterBorderLineHeight = 1;

  //LogIn TextField Widget
  //Image
  String logInWidgetHidePasswordIcon = "assets/svg/password_hide_eye.svg";
  String logInWidgetUnHidePasswordIcon = "assets/svg/password_unhide_eye.svg";

  //Size
  double logInWidgetEdittextWidth = 327;
  double logInWidgetEdittextHeight = 40;
  double logInWidgetLineBorderHeight = 1;
  double logInWidgetIconWidth = 24;
  double logInWidgetIconHeight = 24;
  double logInEdittextHintTextSize = 14;
  double logInEdittextTextSize = 14;

  //Color
  Color logInEdittextLineBorderLightColor = const Color(0xFFC7882B);
  Color logInEdittextTextLightColor = const Color(0xFFC7882B);
  Color logInEdittextIconLightColor = const Color(0xFFC7882B);
  Color logInEdittextLineBorderDarkColor = const Color(0xFFC7882B);
  Color logInEdittextTextDarkColor = const Color(0xFFC7882B);
  Color logInEdittextIconDarkColor = const Color(0xFFC7882B);

  //Padding
  double logInEdittextLeftPadding = 10;

  //Search Gpt widget
  //Image
  String searchGptWidgetEnterArrowIcon = "assets/svg/enter_arrow_icon.svg";
  String searchGptWidgetCrossMarkIcon = "assets/svg/cross_icon.svg";
  String searchGptWidgetMicOnIcon = "assets/svg/mic_on_icon.svg";

  //Padding
  double searchGptWidgetLeftPadding = 16;
  double searchGptWidgetEdittextInnerHorizontalPadding = 24;

  //Size
  double searchGptWidgetEdittextWidth = 380;
  double searchGptWidgetEdittextHeight = 50;
  double searchGptWidgetEdittextBorderHeight = 16;
  double searchGptWidgetEdittextHintTextSize = 14;
  double searchGptWidgetEdittextTextSize = 12;
  double searchGptWidgetEdittextIconWidth = 18;
  double searchGptWidgetEdittextIconHeight = 18;
  double searchGptWidgetEnterOuterButtonIconWidth = 50;
  double searchGptWidgetEnterOuterButtonIconHeight = 50;
  double searchGptWidgetEnterButtonIconWidth = 26;
  double searchGptWidgetEnterButtonIconHeight = 26;

  //Color
  Color searchGptWidgetEdittextOuterBorderLineLightColor =
      const Color(0xFFFFFFFF);
  Color searchGptWidgetEdittextOuterBackgroundLightColor =
      const Color(0xFFFFFFFF);
  Color searchGptWidgetEdittextTextLightColor = const Color(0xFFAF6A06);
  Color searchGptEnterBackgroundStartLightColor = const Color(0xFFC57908);
  Color searchGptEnterBackgroundEndLightColor = const Color(0xFF643502);
  Color searchGptEnterIconLightColor = const Color(0xFFFFFFFF);
  Color searchGptMicIconLightColor = const Color(0xFF757575);
  Color searchGptWidgetEdittextOuterBorderLineDarkColor =
      const Color(0xFF353535);
  Color searchGptWidgetEdittextOuterBackgroundDarkColor =
      const Color(0xFF353535);
  Color searchGptWidgetEdittextTextDarkColor = const Color(0xFFC7882B);
  Color searchGptEnterBackgroundDarkColor = const Color(0xFF5C4209);
  Color searchGptEnterIconDarkColor = const Color(0xFFFFFFFF);
  Color searchGptMicIconDarkColor = const Color(0xFFC7882B);

  //Speaker Logo
  //Image
  String speakerWidgetIcon = "assets/svg/speaker.svg";
  String speakerOnWidgetIcon = "assets/svg/speaker_on.svg";

  //Size
  double speakerWidgetIconOuterWidth = 30;
  double speakerWidgetIconOuterHeight = 30;
  double speakerWidgetIconWidth = 15;
  double speakerWidgetIconHeight = 15;

  //Color
  Color speakerWidgetIconBackgroundColor = const Color(0xFFE67647);

  //App Logo
  String appLogoWidgetLightImage = "assets/png/app_logo.png";
  String appLogoWidgetDarkImage = "assets/png/app_logo_dark.png";

  //Splash Screen
  //Image
  String splashScreenLeftDesignImage = "assets/svg/app_logo_left_design.svg";
  String splashScreenRightDesignImage = "assets/svg/app_logo_right_design.svg";
  String splashScreenBackgroundLogo = "assets/png/background_logo.png";
  String splashScreenImage = "assets/png/splash_screen.png";
  String splashScreenImageDark = "assets/png/splash_screen_dark.png";

  //Size
  double splashScreenBackgroundLogoWidth = 428;
  double splashScreenBackgroundLogoHeight = 318;
  double splashScreenLeftDesignWidth = 136;
  double splashScreenLeftDesignHeight = 259;
  double splashScreenRightDesignWidth = 150;
  double splashScreenRightDesignHeight = 286;
  double splashScreenAppLogoWidth = 239;
  double splashScreenAppLogoHeight = 67;

  //color
  Color splashScreenGradiantStartBackgroundColor = const Color(0xFFFBF8F1);
  Color splashScreenGradiantEndBackgroundColor = const Color(0xFFF5ECDA);

  //Padding
  double splashScreenTopAppLogoPadding = 436;
  double splashScreenTopBackgroundPadding = 201;
  double splashScreenTopLeftDesignPadding = 400;
  double splashScreenTopRightDesignPadding = 217;

  //DashboardScreen
  //Image
  //String dashboardScreenAppLogo = "assets/png/app_logo.png";
  String dashboardScreenEnterArrowIcon = "assets/svg/enter_arrow_icon.svg";
  String dashboardScreenMicOnIcon = "assets/svg/mic_on_icon.svg";

  //Size
  double dashboardScreenAppLogoWidth = 246;
  double dashboardScreenAppLogoHeight = 49;
  double dashboardScreenCategoryBorderWidth = 230;
  double dashboardScreenCategoryBorderHeight = 40;
  double dashboardScreenBottomContentTextSize = 12;
  double dashboardScreenCopyRightTextSize = 12;

  //Color
  Color dashboardScreenGradiantFirstackgroundLightColor =
      const Color(0xFF9D202E);
  Color dashboardScreenGradiantSecondBackgroundLightColor =
      const Color(0xFFFFD027);
  Color dashboardScreenGradiantThirdBackgroundLightColor =
      const Color(0xFFF2A174);
  Color dashboardScreenGradiantFourthBackgroundLightColor =
      const Color(0xFFF6DC99);
  Color dashboardScreenBottomContentTextLightColor = const Color(0xFF999999);
  Color dashboardScreenBottomCopyRightTextLightColor = const Color(0xFF8D8985);
  Color dashboardScreenGradiantStartBackgroundDarkColor =
      const Color(0xFF010101);
  Color dashboardScreenGradiantEndBackgroundDarkColor = const Color(0xFF523806);
  Color dashboardScreenBottomContentTextDarkColor = const Color(0xFF999999);
  Color dashboardScreenBottomCopyRightTextDarkColor = const Color(0xFFFFFFFF);

  //Padding
  double dashboardScreenLeftPadding = 16;
  double dashboardScreenRightPadding = 16;
  double dashboardScreenTopPadding = 49;
  double dashboardScreenTopAppLogoPadding = 30;
  double dashboardScreenTopCategoryPadding = 42;
  double dashboardScreenBetweenCategoryPadding = 24;
  double dashboardScreenBetweenCategoryBackgroundImage = 33;
  double dashboardScreenEdittextInnerHorizontalPadding = 24;
  double dashboardScreenBottomEdittextPadding = 9;
  double dashboardScreenBottomContentPadding = 48;
  double dashboardScreenBottomCopyRightPadding = 34;
  double dashboardScreenBottomContentLeftPadding = 47;
  double dashboardScreenBottomContentRightPadding = 47;

  //GPT Screen
  //Image
  //String gptScreenAppLogo = "assets/png/app_logo.png";

  //Size
  double gptScreenAppLogoWidth = 113;
  double gptScreenAppLogoHeight = 31;
  double gptScreenSearchResultTextSize = 14;
  double gptScreenSearchResultCornerRadius = 10;

  //Color
  Color gptScreenBackgroundStartLightColor = const Color(0xFFFFFFFF);
  Color gptScreenBackgroundEndLightColor = const Color(0xFFFFFFFF);
  Color gptScreenSearchResultBackgroundLightColor = const Color(0xFFF8F8F8);
  Color gptScreenSearchResultTextLightColor = const Color(0xFF353535);
  Color gptScreenBackgroundStartDarkColor = const Color(0xFF030202);
  Color gptScreenBackgroundEndDarkColor = const Color(0xFF503706);
  Color gptScreenSearchResultBackgroundDarkColor = const Color(0xFF2D281E);
  Color gptScreenSearchResultTextDarkColor = const Color(0xFFFFFFFF);

  //Padding
  double gptScreenLeftPadding = 16;
  double gptScreenRightPadding = 16;
  double gptScreenSearchResultLeftPadding = 24;
  double gptScreenSearchResultRightPadding = 24;
  double gptScreenSearchResultInnerLeftPadding = 8;
  double gptScreenSearchResultInnerRightPadding = 8;
  double gptScreenSearchResultInnerTopPadding = 32;
  double gptScreenSearchResultInnerBottomPadding = 32;
  double gptScreenTopPadding = 115;
  double gptScreenTopSearchPadding = 16;
  double gptScreenTopSearchResultPadding = 32;

  //Sign in/up Screen
  //File
  String signInScreenCountryCodeJsonFile = "assets/file/country_codes.json";

  //Image
  String signInScreenGoogleIcon = "assets/svg/google_icon.svg";
  String signInScreenDropdownIcon = "assets/svg/country_dropdown.svg";
  String signInScreenIndiaFlagIcon = "assets/svg/india_flag_icon.svg";
  String signInScreenAppleIcon = "assets/svg/apple_logo.svg";

  //Size
  double signInScreenAppLogoWidth = 246;
  double signInScreenAppLogoHeight = 49;
  double signInScreenTextFieldBorderLineHeight = 1;
  double signInScreenTextFieldHintSize = 14;
  double signInScreenTextFieldSize = 14;
  double signInScreenEyeIconWidth = 24;
  double signInScreenEyeIconHeight = 24;
  double signInScreenButtonWidth = 327;
  double signInScreenButtonHeight = 50;
  double signInScreenSwitchTextSize = 12;
  double signInScreenCopyRightTextSize = 12;
  double signInScreenBorderLineWidth = 50;
  double signInScreenBorderLineHeight = 0.5;
  double signInScreenLogInTextSize = 12;
  double signInScreenGoogleLogoImageWidth = 25;
  double signInScreenInActiveButtonTextSize = 14;
  double signInScreenActiveButtonTextSize = 16;
  double signInScreenActiveButtonRadius = 20;
  double signInScreenAppleButtonWidth = 327;
  double signInScreenGoogleButtonWidth = 327;
  double signInScreenAppleButtonHeight = 50;
  double signInScreenGoogleButtonHeight = 50;

  //Color
  Color signInScreenGradiantStartBackgroundLightColor = const Color(0xFFF6EDDB);
  Color signInScreenGradiantEndBackgroundLightColor = const Color(0xFFFFFFFF);
  Color signInScreenEdittextLineBorderLightColor = const Color(0xFF7F5002);
  Color signInScreenEdittextTextLightColor = const Color(0xFF7F5002);
  Color signInScreenSwitchTextLightColor1 = const Color(0xFF8D8985);
  Color signInScreenSwitchTextLightColor2 = const Color(0xFFC7882B);
  Color signInScreenCopyRightsTextLightColor = const Color(0xFF8D8985);
  Color signInScreenGradiantStartBackgroundDarkColor = const Color(0xFF050303);
  Color signInScreenGradiantEndBackgroundDarkColor = const Color(0xFF4F3606);
  Color signInScreenEdittextLineBorderDarkColor = const Color(0xFFF5E6BB);
  Color signInScreenEdittextTextDarkColor = const Color(0xFFF5E6BB);
  Color signInScreenSwitchTextDarkColor1 = const Color(0xFF8D8985);
  Color signInScreenSwitchTextDarkColor2 = const Color(0xFFC7882B);
  Color signInScreenCopyRightsTextDarkColor = const Color(0xFFCACACA);
  Color signInScreenBorderLightColor = const Color(0xFF8D8985);
  Color signInScreenBorderDarkColor = const Color(0xFF8D8985);
  Color signInScreenLogInTextLightColor = const Color(0xFF8D8985);
  Color signInScreenLogInTextDarkColor = const Color(0xFF8D8985);
  Color signInScreenInActiveTextLightColor = const Color(0xFF8D8985);
  Color signInScreenInActiveTextDarkColor = const Color(0xFFC6C6C6);
  Color signInScreenActiveButtonBackgroundStartColor = const Color(0xFFC7882B);
  Color signInScreenActiveButtonBackgroundEndColor = const Color(0xFFC7882B);
  Color signInScreenActiveButtonTextColor = const Color(0xFFFFFFFF);
  Color signInScreenDropDownIconDarkColor = const Color(0xFFC7882B);
  Color signInScreenDropDownIconLightColor = const Color(0xFFC7882B);

  //Padding
  double signInScreenLeftPadding = 50;
  double signInScreenBottomCopyRightsPadding = 55;
  double signInScreenBackgroundImageCopyRightPadding = 20;
  double signInScreenBottomEdittextPadding = 20;
  double signInScreenBottomButtonPadding = 20;
  double signInScreenTopBackButtonPadding = 115;
  double signInScreenTopAppLogoPadding = 73;
  double signInScreenBorderTextPadding = 16;
  double signInScreenLogInTextBottomPadding = 22;
  double signInScreenGoogleLogoBottomPadding = 20;
  double signInScreenEdittextPadding = 35;
  double signInScreenBottomMailButtonPadding = 50;
  double signInScreenActiveInnerButtonHorizontalPadding = 50;
  double signInScreenActiveInnerButtonVerticalPadding = 10;

  // Setting Screen
  //Size
  double settingScreenTitleTextSize = 18;
  double settingScreenContentTextSize = 16;
  double settingScreenSwitchButtonWidth = 40;
  double settingScreenSwitchButtonHeight = 20;
  double settingScreenSwitchButtonInnerHeight = 16;
  double settingScreenDropDownWidth = 14;
  double settingScreenLanguageTextSize = 12;

  //Color
  Color settingScreenBackgroundLightColor = const Color(0xFFFFFFFF);
  Color settingScreenTitleTextLightColor = const Color(0xFF353535);
  Color settingScreenContentTextLightColor = const Color(0xFF353535);
  Color settingScreenSwitchButtonLightStartColor = const Color(0xFFF5E5B7);
  Color settingScreenSwitchButtonLightEndColor = const Color(0xFFE3BC4A);
  Color settingScreenInnerSwitchLightColor = const Color(0xFF000000);
  Color settingScreenDropdownArrowLightColor = const Color(0xFF000000);
  Color settingScreenLanguageTextLightColor = const Color(0xFF999999);
  Color settingScreenBackgroundDarkStartColor = const Color(0xFF020202);
  Color settingScreenBackgroundDarkEndColor = const Color(0xFF4F3604);
  Color settingScreenTitleTextDarkColor = const Color(0xFFFFFFFF);
  Color settingScreenContentTextDarkColor = const Color(0xFFFFFFFF);
  Color settingScreenSwitchButtonStartDarkColor = const Color(0xFFF5E5B7);
  Color settingScreenSwitchButtonEndDarkColor = const Color(0xFFE3BC4A);
  Color settingScreenInnerSwitchDarkColor = const Color(0xFFFFFFFF);
  Color settingScreenDropdownArrowDarkColor = const Color(0xFFFFFFFF);
  Color settingScreenLanguageTextDarkColor = const Color(0xFFFFFFFF);

  //Padding
  double settingScreenLeftPadding = 28;
  double settingScreenTopPadding = 50;
  double settingScreenTopLanguagePadding = 30;
  double settingScreenTopDarkModePadding = 20;
  double settingScreenTopReportPadding = 20;
  double settingScreenTopPrivacyPadding = 20;
  double settingScreenTopRateUsPadding = 20;
  double settingScreenTopDeleteAccountPadding = 20;
  double settingScreenPaddingBetweenTextAndDropDown = 19;
  double settingScreenSwitchPadding = 2;

  //SettingScreen AlertDialog box
  //Size
  double settingScreenAlertDialogBoxRadius = 6;
  double settingScreenAlertRadioButtonWidth = 21;
  double settingScreenAlertTextSize = 14;
  double settingScreenAlertTextWidth = 100;

  //Color
  Color settingScreenAlertBackgroundLightColor = const Color(0xFFFFFFFF);
  Color settingScreenAlertBackgroundDarkColor = const Color(0xFF2D281E);
  Color settingScreenAlertRadioActiveColor = const Color(0xFFA36501);
  Color settingScreenAlertRadioInActiveLightColor = const Color(0xFF999999);
  Color settingScreenAlertRadioInActiveDarkColor = const Color(0xFFFFFFFF);
  Color settingScreenAlertTextLightColor = const Color(0xFF999999);
  Color settingScreenAlertTextDarkColor = const Color(0xFFFFFFFF);

  //Padding
  double settingScreenAlertDialogBoxInnerPadding = 24;
  double settingScreenAlertDialogBoxPaddingBetweenRadioText = 16;
  double settingScreenAlertDialogBetweenLanguage = 28;
  double settingScreenAlertDialogBoxBottomPadding = 10;

  //Term Use Screen
  //Size
  double termUseScreenTitleTextSize = 18;
  double termUseScreenContentTextSize = 16;

  //Color
  Color termUseScreenBackgroundStartLightColor = const Color(0xFFFFFFFF);
  Color termUseScreenBackgroundEndLightColor = const Color(0xFFFFFFFF);
  Color termUseScreenTitleTextLightColor = const Color(0xFF353535);
  Color termUseScreenBackgroundStartDarkColor = const Color(0xFF030302);
  Color termUseScreenBackgroundEndDarkColor = const Color(0xFF4E3604);
  Color termUseScreenTitleTextDarkColor = const Color(0xFFFFFFFF);

  //Padding
  double termUseScreenLeftPadding = 28;
  double termUseScreenTopPadding = 44;
  double termUseScreenTopLanguagePadding = 30;

  //Bottom Navigation Bar
  //Image
  String bottomNavigationIcon = "assets/svg/bottom_navigation_icon.svg";
  String bottomNavigationSettingIcon = "assets/svg/bottom_setting.svg";
  String bottomNavigationBookLightIcon = "assets/png/book_image.png";
  String bottomNavigationBookDarkIcon = "assets/png/book_image_dark.png";

  //Size
  double bottomNavigationBarHeight = 25;
  double bottomNavigationBarBackgroundHeight = 70;
  double bottomNavigationBarBackgroundCornerWidth = 4;
  double bottomNavigationBarShadowOpacity = 0.4;
  double bottomNavigationBarBlurRadius = 5;
  double bottomNavigationBarIconHeight = 24;
  double bottomNavigationBarTextSize = 10;
  double bottomNavigationBarOuterBorderHeight = 63;
  double bottomNavigationBarInnerBorderHeight = 54;

  //Color
  Color bottomNavigationBarBackgroundColor = const Color(0xFFA36501);
  Color bottomNavigationBarShadowColor = const Color(0xFF000000);
  Color bottomNavigationBarTextColor = const Color(0xFFFFFFFF);
  Color bottomNavigationBarBorderColor = const Color(0xFFF4E0A8);
  Color bottomNavigationBarBackgroundIconColor = const Color(0xFFFFFFFF);
  Color bottomNavigationBarActiveIcon = const Color(0xFFA36501);

  //Padding
  double bottomNavigationPaddingBetweenIconText = 9;
  double bottomNavigationBottomPadding = 9;

  //Chapter Screen
  //Image
  String chapterScreenDefaultProfilePictureIconLight =
      "assets/svg/default_profile_picture_light.svg";
  String chapterScreenDefaultProfilePictureIconDark =
      "assets/svg/default_profile_picture_dark.svg";
  String chapterScreenFacebookIconLight = "assets/svg/facebook_icon_light.svg";
  String chapterScreenFacebookIconDark = "assets/svg/facebook_icon_dark.svg";
  String chapterScreenInstagramIconLight =
      "assets/svg/instagram_icon_light.svg";
  String chapterScreenInstagramIconDark = "assets/svg/instagram_icon_dark.svg";
  String chapterScreenMenuIconLight = "assets/svg/menu_icon_light.svg";
  String chapterScreenMenuIconDark = "assets/svg/menu_icon_dark.svg";
  String chapterScreenTwitterIconLight = "assets/svg/twitter_icon_light.svg";
  String chapterScreenTwitterIconDark = "assets/svg/twitter_icon_dark.svg";
  String chapterScreenYoutubeIconLight = "assets/svg/youtube_icon_light.svg";
  String chapterScreenYoutubeIconDark = "assets/svg/youtube_icon_dark.svg";
  String chapterScreenProfileLightIcon = "assets/svg/profile_icon.svg";
  String chapterScreenSettingLightIcon = "assets/svg/setting_icon.svg";
  String chapterScreenProfileDarkIcon = "assets/svg/profile_dark_icon.svg";
  String chapterScreenSettingDarkIcon = "assets/svg/setting_dark_icon.svg";
  String chapterScreenBottomDesignIcon = "assets/svg/bottom_design_icon.svg";
  String chapterScreenTopDesignIcon = "assets/svg/top_design_icon.svg";
  String chapterDetailScreenChangeLanguageButtonIcon =
      "assets/svg/change_language_button_icon.svg";
  String chapterDetailScreenQiblaIcon = "assets/png/qibla_image.png";
  String chapterDetailScreenCompassIcon = "assets/svg/direction_compass.svg";

  //Size
  double chapterScreenMenuIconWidth = 16;
  double chapterScreenMenuIconHeight = 16;
  double chapterScreenDefaultProfilePictureIconWidth = 40;
  double chapterScreenDefaultProfilePictureIconHeight = 40;
  double chapterScreenYoutubeIconWidth = 30;
  double chapterScreenYoutubeIconHeight = 21;
  double chapterScreenFacebookIconWidth = 11;
  double chapterScreenFacebookIconHeight = 21;
  double chapterScreenTwitterIconWidth = 21;
  double chapterScreenTwitterIconHeight = 21;
  double chapterScreenInstagramIconWidth = 21;
  double chapterScreenInstagramIconHeight = 21;
  double chapterScreenProfileIconWidth = 21;
  double chapterScreenProfileIconHeight = 21;
  double chapterScreenSettingIconWidth = 21;
  double chapterScreenSettingIconHeight = 21;
  double chapterScreenAppLogoWidth = 180;
  double chapterScreenAppLogoHeight = 50;
  double chapterScreenContentTextSize = 12;
  double chapterScreenCategoryButtonWidth = 124;
  double chapterScreenCategoryButtonHeight = 40;
  double chapterScreenCategoryTextSize1 = 14;
  double chapterScreenCategoryTextSize2 = 14;
  double chapterScreenRecentChapterTextSize = 12;
  double chapterScreenClearAllTextSize = 14;
  double chapterScreenAllChapterTextSize = 12;
  double chapterScreenMenuProfileTextSize = 16;

  //Color
  Color chapterScreenBackgroundStartLightColor = const Color(0xFFFFFFFF);
  Color chapterScreenBackgroundEndLightColor = const Color(0xFFFFFFFF);
  Color chapterScreenContentTextLightColor = const Color(0xFF999999);
  Color chapterScreenSelectedCategoryTextLightColor1 = const Color(0xFF7F5002);
  Color chapterScreenSelectedCategoryTextLightColor2 = const Color(0xFF999999);
  Color chapterScreenRecentChapterTextLightColor = const Color(0xFF9A3524);
  Color chapterScreenChapterClearAllTextLightColor = const Color(0xFFCE8610);
  Color chapterScreenAllChapterTextLightColor = const Color(0xFF9A3524);
  Color chapterScreenContentTextDarkColor = const Color(0xFFFFFFFF);
  Color chapterScreenBackgroundStartDarkColor = const Color(0xFF3D2E0A);
  Color chapterScreenBackgroundEndDarkColor = const Color(0xFF42230F);
  Color chapterScreenSelectedCategoryTextDarkColor1 = const Color(0xFFF5E6BB);
  Color chapterScreenSelectedCategoryTextDarkColor2 = const Color(0xFFFFFFFF);
  Color chapterScreenRecentChapterTextDarkColor = const Color(0xFFFFFFFF);
  Color chapterScreenChapterClearAllTextDarkColor = const Color(0xFFCE8610);
  Color chapterScreenAllChapterTextDarkColor = const Color(0xFFFFFFFF);
  Color chapterScreenMenuDrawerBackgroundStartDarkColor =
      const Color(0xFF000000);
  Color chapterScreenMenuDrawerBackgroundEndDarkColor = const Color(0xFF6D540B);
  Color chapterScreenMenuDrawerBackgroundStartLightColor =
      const Color(0xFFF5ECD4);
  Color chapterScreenMenuDrawerBackgroundEndLightColor =
      const Color(0xFFFFFFFF);
  Color chapterScreenMenuDrawerProfileBackgroundStartDarkColor =
      const Color(0xFF7D4E01);
  Color chapterScreenMenuDrawerProfileBackgroundEndDarkColor =
      const Color(0xFF000000);
  Color chapterScreenMenuDrawerProfileBackgroundStartLightColor =
      const Color(0xFFFBE4AB);
  Color chapterScreenMenuDrawerProfileBackgroundEndLightColor =
      const Color(0xFFFFFFFF);
  Color chapterScreenMenuProfileTextColorLight = const Color(0xFFDB7F5E);
  Color chapterScreenMenuProfileTextColorDark = const Color(0xFFDB7F5E);

  //Padding
  double chapterScreenLeftPadding = 16;
  double chapterScreenRightPadding = 16;
  double chapterScreenTopAppLogoPadding = 52;
  double chapterScreenTopSearchPadding = 21;
  double chapterScreenTopContentPadding = 16;
  double chapterScreenBottomContentPadding = 39;
  double chapterScreenTopCategoryButtonPadding = 30;
  double chapterScreenTopCategoryTextPadding = 26;
  double chapterScreenTopRecentChapterTextPadding = 20;
  double chapterScreenTopClearAllTextPadding = 12;
  double chapterScreenBottomClearAllTextPadding = 20;
  double chapterScreenBottomAllChapterTextPadding = 20;

  String penIcon = "assets/svg/pen_icon.svg";
  String getCardIcon = "assets/svg/card_design.svg";
  String getDropDownIcon = "assets/svg/drop_down.svg";
  String changeLanguageIcon = "assets/svg/change_language_icon.svg";

  //CategoryDetail Screen
  //Image
  String categoryDetailScreenSearchIcon = "assets/svg/search_icon.svg";
  String categoryDetailScreenPlayIcon = "assets/svg/play_icon.svg";
  String categoryDetailScreenPauseIcon = "assets/svg/pause_icon.svg";

  //Size
  double categoryDetailScreenNumberBackgroundWidth = 24;
  double categoryDetailScreenNumberTextSize = 12;
  double categoryDetailScreenTitleTextSize = 18;
  double categoryDetailScreenSearchIconWidth = 28;
  double categoryDetailScreenTitleChapterTextSize = 14;

  //Color
  Color categoryDetailScreenBackgroundStartLightColor = const Color(0xFFFFFFFF);
  Color categoryDetailScreenBackgroundEndLightColor = const Color(0xFFFFFFFF);
  Color categoryDetailScreenBackgroundStartDarkColor = const Color(0xFF3D2E0A);
  Color categoryDetailScreenBackgroundEndDarkColor = const Color(0xFF42230F);
  Color categoryDetailScreenNumberStartColor = const Color(0xFFCE8610);
  Color categoryDetailScreenNumberMiddleColor = const Color(0xFFD4A11D);
  Color categoryDetailScreenNumberEndColor = const Color(0xFFF8BE1B);
  Color categoryDetailScreenNumberTextColor = const Color(0xFFF8F8F8);
  Color categoryDetailScreenTitleTextLightColor = const Color(0xFF353535);
  Color categoryDetailScreenTitleChapterText1LightColor =
      const Color(0xFF7F5002);
  Color categoryDetailScreenTitleChapterText2LightColor =
      const Color(0xFF999999);
  Color categoryDetailScreenTitleTextDarkColor = const Color(0xFFFFFFFF);
  Color categoryDetailScreenTitleChapterText1DarkColor =
      const Color(0xFFF5E6BB);
  Color categoryDetailScreenTitleChapterText2DarkColor =
      const Color(0xFFFFFFFF);
  Color categoryDetailScreenSearchIconLightColor = const Color(0xFF353535);
  Color categoryDetailScreenSearchIconDarkColor = const Color(0xFFFFFFFF);

  //Padding
  double categoryDetailScreenTopPadding = 68;
  double categoryDetailScreenPaddingTitle = 24;
  double categoryDetailScreenTopChapterPadding = 0;
  double categoryDetailScreenHorizontalPadding = 16;
  double categoryDetailScreenTopChangeEditionPadding = 31;
  double categoryDetailScreenTopListviewPadding = 38;

  String profileCircleIcon = "assets/svg/profile_circle.svg";
  String aboutUsUrl = "https://mygitagpt.com/privacy-policy";
  String contactUsUrl = "https://9xtechnology.com/contact.php";
  String googleSocialMediaText = "google";
  String appleSocialMediaText = "apple";

  //API Call
  String baseUrl = "https://api.mygitagpt.com/gita/";
  String gptUrl = "https://api.mygitagpt.com/api/v1/user/";
  String searchApiUrl = "search/";
  String homeChapterEndPoint = "chapters/";
  String summaryChapterEndPoint = "chapter/";
  String versesChapterEndPoint = "verses/";
  String textToSpeechEndPoint = "text-to-speach/";
  String registerAPIEndPoint = "register/";
  String logInAPIEndPoint = "login/";
  String socialMediaAPIEndPoint = "continue-with-social/";
  String socialMediaLogInAPIEndPoint = "login-with-social/";
  String deleteAccountAPIEndPoint = "delete-my-account/";
  String forgetPasswordEndPoint = "forgot-password/";

  String appleStoreId = "6478273332";
  String googleStoreId = "com.gitagpt.application";

  String facebookLink = "https://www.facebook.com/mygitagpt";
  String instagramLink = "https://www.instagram.com/mygitagpt/";
  String twitterLink = "https://twitter.com/mygitagpt";

  // BOOK PAGE
  //1.Texts
  String oldTestament = "Old Testament";
  String newTestament = "New Testament";
  String theBookOf = " The Book Of";
  String bible = "Bible";
  String languageDropdown = "Language";
  String trasilationsEditions = "Trasilations/Editions";
  String all = "All";
//2.Paddings

  double testmentBoxTop = 40;
  double firstLeft = 66;
  double secondLeft = 23;
}
