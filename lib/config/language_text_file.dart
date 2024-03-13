import 'dart:ui';

class LanguageTextFile {
  
  String getHindiLanguageCode = "hi";
  String getEnglishLanguageCode = "en";

  List<String> getLanguageList() {
    return [
      getHindiLanguageCode,
      getEnglishLanguageCode,
    ];
  }

  TextDirection getTextDirection(String getLanguageCode) {
    if (getLanguageCode == "en") {
      return TextDirection.ltr;
    } else if (getLanguageCode == "hi") {
      return TextDirection.ltr;
    }
    return TextDirection.rtl;
  }

  getLanguageName(String getLanguageCode) {
    switch (getLanguageCode) {
      case "am":
        return "Amharic";
      case "ar":
        return "Arabic";
      case "az":
        return "Azerbaijani";
      case "ber":
        return "Berber";
      case "bn":
        return "Bangla";
      case "cs":
        return "Czech";
      case "de":
        return "German";
      case "dv":
        return "Maldivian";
      case "en":
        return "English";
      case "es":
        return "Spanish";
      case "fa":
        return "Persian";
      case "fr":
        return "French";
      case "ha":
        return "Hausa";
      case "hi":
        return "हिंदी";
      case "id":
        return "Indonesian";
      case "it":
        return "Italian";
      case "ja":
        return "Japanese";
      case "ko":
        return "Korean";
      case "ku":
        return "Kurdish";
      case "ml":
        return "Malayalam";
      case "nl":
        return "Dutch";
      case "no":
        return "Norwegian";
      case "pl":
        return "Polish";
      case "ps":
        return "Pashto, Pushto";
      case "pt":
        return "Portuguese";
      case "ro":
        return "Romanian";
      case "ru":
        return "Russian";
      case "sd":
        return "Sindhi";
      case "so":
        return "Somali";
      case "sq":
        return "Albanian";
      case "sv":
        return "Swedish";
      case "sw":
        return "Swahili";
      case "ta":
        return "Tamil";
      case "tg":
        return "Tajik";
      case "th":
        return "Thai";
      case "tr":
        return "Turkish";
      case "tt":
        return "Tatar";
      case "ug":
        return "Uighur";
      case "ur":
        return "Urdu";
      case "uz":
        return "Uzbek";
      default:
        return "";
    }
  }

  //Search GPT Widget
  String getSearchGPTWidgetHintText() {
    return "Tell us how can we help you!";
  }

  //Dashboard Screen
  String getDashboardScreenChapterText() {
    return "BOOK";
  }

  String getDashboardScreenBottomContentText() {
    return "Free Research Preview. Bible GPT may produce inaccurate information about people, places, or facts.";
  }

  String getDashboardScreenCopyRightText() {
    return "© 2023 Copyright by Bible GPT";
  }

  //Bottom Navigation Bar
  String getBottomNavigationChapterText() {
    return "Book";
  }

  String getBottomNavigationSettingText() {
    return "Settings";
  }

  String getBottomNavigationContentText() {
    return "Free Research Preview. Bible GPT may produce inaccurate information about people, places, or facts.";
  }

  //Chapter Screen
  String getChapterScreenChapterText() {
    return "BOOK";
  }

  String getChapterScreenChapterDataText() {
    return "Book";
  }

  String getChapterScreenSelectedChapterText1() {
    return "Rehal";
  }

  String getChapterScreenSelectedChapterText2() {
    return " / Books";
  }

  String getChapterScreenRecentChapterText() {
    return "Recent Chapters";
  }

  String getChapterScreenClearAllText() {
    return "Clear All";
  }

  String getChapterScreenAllChapterText() {
    return "All  Books";
  }

  //Category Detail Screen
  String getCategoryDetailScreenRehalText() {
    return "Rehal / ";
  }

  String getCategoryDetailScreenChaptersText() {
    return "Books";
  }

  String getCategoryDetailScreenPlayAllPlayButtonText() {
    return "Play all";
  }

  String getCategoryDetailScreenPlayAllPauseButtonText() {
    return "Pause";
  }

  String getCategoryDetailScreenBackText() {
    return "Back";
  }

  String getCategoryDetailScreenNextText() {
    return "Next";
  }

  // Alert box
  String getCategoryDetailAlertLanguageText() {
    return "Language";
  }

  String getCategoryDetailAlertTypeText() {
    return "Type";
  }

  String getCategoryDetailAlertEditionText() {
    return "Edition";
  }

  String getCategoryDetailAlertSubmitText() {
    return "Submit";
  }

  String getCategoryDetailScreenChangeLanguageButtonIconText() {
    return "Change Edition";
  }

  //Setting Screen
  String getLanguageSettingTitleText() {
    return "Settings";
  }

  String getLanguageSettingLanguageChangeText() {
    return "Language change";
  }

  String getLanguageSettingDarkModeText() {
    return "Enable dark mode";
  }

  String getLanguageSettingReportText() {
    return "Report";
  }

  String getLanguageSettingTermPrivacyText() {
    return "About & Policies";
  }

  String getLanguageSettingContactText() {
    return "Contact Us";
  }

  String getLanguageSettingRateUsText() {
    return "Rate us";
  }

  String getLanguageSettingDeleteAccountText() {
    return "Delete account";
  }

  //Terms Policy Screen
  String getTermPolicyScreenTitleText() {
    return "Terms of use";
  }

  String getSignInScreenFirstNameHintText() {
    return "First Name";
  }

  String getSignInScreenLastNameHintText() {
    return "Last Name";
  }

  //SignIn Screen
  String getSignInScreenEmailHintText() {
    return "Email";
  }

  String getSignInScreenNumberHintText() {
    return "Number";
  }

  String getSignInScreenPasswordHintText() {
    return "Password";
  }

  String getSignInScreenConfirmPasswordHintText() {
    return "Confirm password";
  }

  String getSignInScreenLogInButtonText() {
    return "LOGIN";
  }

  String getSignInScreenRegisterButtonText() {
    return "REGISTER";
  }

  String getSignInScreenLogInAppleButtonText() {
    return "LOG IN WITH APPLE";
  }

  String getSignInScreenRegisterAppleButtonText() {
    return "SIGN UP WITH APPLE";
  }

  String getSignInScreenLogInGoogleButtonText() {
    return "LOG IN WITH GOOGLE";
  }

  String getSignInScreenRegisterGoogleButtonText() {
    return "SIGN UP WITH GOOGLE";
  }

  String getSignInScreenSwitchLogInText1() {
    return "Don’t have an Account ? ";
  }

  String getSignInScreenSwitchLogInText2() {
    return "Register";
  }

  String getSignInScreenSwitchRegisterText1() {
    return "Already have an Account ? ";
  }

  String getSignInScreenSwitchRegisterText2() {
    return "Login";
  }

  String getSignInScreenCopyRightText() {
    return "© 2023 Copyright by Bible GPT";
  }

  String getSignInScreenGoogleContentText() {
    return "or login with";
  }

  String getSignInScreenNumberButtonText() {
    return "By Phone number";
  }

  String getSignInScreenEmailButtonText() {
    return "By Email";
  }

  //Profile Screen
  String getProfileScreenProfileTitleText() {
    return "Profile";
  }

  String getProfileScreenLogoutText() {
    return "Log out";
  }

  String getProfileScreenFullNameHintText() {
    return "Full name";
  }

  String getProfileScreenUserNameHintText() {
    return "Email/Mobile Number";
  }

  //No Network Screen
  String getNoInternetScreenTitleText() {
    return "NO INTERNET CONNECTION";
  }

  String getNoInternetScreenContentText() {
    return "There was a problem connecting to the internet. Please hit Retry to connect again";
  }

  String getNoInternetScreenRetryButtonText() {
    return "RETRY";
  }
}
