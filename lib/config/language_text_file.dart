import 'dart:ui';

import 'package:bible_gpt/class/change_language_local.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String getSearchGPTWidgetHintText(String language) {
    if (language == 'en') {
      return "Tell us how can we help you!";
    } else if (language == 'hi') {
      return "हमें बताएं कि हम आपकी कैसे मदद कर सकते हैं!";
    }
    return "";
  }

  //Dashboard Screen
  String getDashboardScreenChapterText() {
    return "BOOK";
  }

  String getDashboardButtonText(String language) {
    if (language == 'en') {
      return "BOOKS";
    } else if (language == 'hi') {
      return "किताब";
    }
    return '';
  }

  String getDashboardScreenBottomContentText(String language) {
    if (language == 'en') {
      return "Free Research Preview. Bible GPT may produce inaccurate information about people, places, or facts.";
    } else if (language == 'hi') {
      return 'निःशुल्क अनुसंधान पूर्वावलोकन. बाइबिल जीपीटी लोगों, स्थानों या तथ्यों के बारे में गलत जानकारी उत्पन्न कर सकता है।';
    }
    return '';
  }

  String getDashboardScreenCopyRightText() {
    return "© 2023 Copyright by Bible GPT";
  }

  //Bottom Navigation Bar
  String getBottomNavigationChapterText(String language) {
    if (language == 'en') {
      return "Book";
    } else if (language == 'hi') {
      return 'किताब';
    }
    return '';
  }

  String getBottomNavigationSettingText() {
    return "Settings";
  }

  String getBottomNavigationContentText(String language) {
    if (language == 'en') {
      return "© 2023 Copyright by Bible GPT";
    } else if (language == 'hi') {
      return "© 2023 कॉपीराइट बाइबिल जीपीटी द्वारा";
    }
    return "";
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

  String getChapterScreenRecentChapterText(String language) {
    if (language == 'en') {
      return "Recent Chapters";
    } else if (language == 'hi') {
      return "हाल के अध्याय";
    }
    return '';
  }

  String getChapterScreenClearAllText(String language) {
    if (language == 'en') {
      return "Clear All";
    } else if (language == 'hi') {
      return "सभी साफ करें";
    }
    return '';
  }

  String getChapterScreenAllChapterText(String language) {
    if (language == 'en') {
      return "All  Books";
    } else if (language == 'hi') {
      return 'सभी पुस्तकें';
    }
    return '';
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
  String getLanguageSettingTitleText(String language) {
    if (language == 'en') {
      return "Settings";
    } else if (language == 'hi') {
      return 'समायोजन';
    }
    return '';
  }

  String getLanguageSettingLanguageChangeText(String language) {
    if (language == 'en') {
      return "Language change";
    } else if (language == 'hi') {
      return 'भाषा परिवर्तन';
    }
    return '';
  }

  String getLanguageSettingDarkModeText(String language) {
    if (language == 'en') {
      return "Enable dark mode";
    } else if (language == 'hi') {
      return 'डार्क मोड सक्षम करें';
    }
    return '';
  }

  String getLanguageSettingReportText() {
    return "Report";
  }

  String getLanguageSettingTermPrivacyText(String language) {
    if (language == 'en') {
      return "About & Policies";
    } else if (language == 'hi') {
      return 'नीतियों के बारे में';
    }

    return "";
  }

  String getLanguageSettingContactText(String language) {
    if (language == 'en') {
      return "Contact Us";
    } else if (language == 'hi') {
      return 'संपर्क करें';
    }
    return "";
  }

  String getLanguageSettingRateUsText(String language) {
    if (language == 'en') {
      return "Rate us";
    } else if (language == 'hi') {
      return 'हमें रेटिंग दें';
    }

    return "";
  }

  String getLanguageSettingDeleteAccountText() {
    return "Delete account";
  }

  //Terms Policy Screen
  String getTermPolicyScreenTitleText() {
    return "Terms of use";
  }

  String getSignInScreenFirstNameHintText(String language) {
    if (language == 'en') {
      return "First Name";
    } else if (language == "hi") {
      return "पहला नाम";
    }
    return "";
  }

  String getSignInScreenLastNameHintText(String language) {
    if (language == 'en') {
      return "Last Name";
    } else if (language == "hi") {
      return "उपनाम";
    }

    return "";
  }

  //SignIn Screen
  String getSignInScreenEmailHintText(String language) {
    if (language == 'en') {
      return "Email";
    } else if (language == "hi") {
      return "ईमेल";
    }

    return "";
  }

  String getSignInScreenNumberHintText(String language) {
    if (language == 'en') {
      return "Number";
    } else if (language == "hi") {
      return "संख्या";
    }
    return "";
  }

  String getSignInScreenPasswordHintText(String language) {
    if (language == 'en') {
      return "Password";
    } else if (language == "hi") {
      return "पासवर्ड";
    }

    return "";
  }

  String getSignInScreenConfirmPasswordHintText(String language) {
    if (language == 'en') {
      return "Confirm password";
    } else if (language == "hi") {
      return "पासवर्ड की पुष्टि कीजिये";
    }
    return "";
  }

  String getSignInScreenLogInButtonText(String language) {
    if (language == 'en') {
      return "LOGIN";
    } else if (language == "hi") {
      return "लॉग इन करें";
    }

    return "";
  }

  String getSignInScreenRegisterButtonText(String language) {
    if (language == 'en') {
      return "REGISTER";
    } else if (language == "hi") {
      return "पंजीकरण करवाना";
    }

    return "";
  }

  String getSignInScreenLogInAppleButtonText() {
    return "LOG IN WITH APPLE";
  }

  String getSignInScreenRegisterAppleButtonText() {
    return "SIGN UP WITH APPLE";
  }

  String getSignInScreenLogInGoogleButtonText(String language) {
    if (language == 'en') {
      return "LOG IN WITH GOOGLE";
    } else if (language == "hi") {
      return "गूगल से लॉग इन करें";
    }
    return "";
  }

  String getSignInScreenRegisterGoogleButtonText(String language) {
    if (language == 'en') {
      return "SIGN UP WITH GOOGLE";
    } else if (language == "hi") {
      return "गूगल के साथ साइन अप करें";
    }
    return "";
  }

  String getSignInScreenSwitchLogInText1(String language) {
    if (language == 'en') {
      return "Don’t have an Account ?  ";
    } else if (language == "hi") {
      return "कोई खाता नहीं है ? ";
    }

    return "";
  }

  String getSignInScreenSwitchLogInText2(String language) {
    if (language == 'en') {
      return "Register ";
    } else if (language == "hi") {
      return "पंजीकरण करवाना";
    }
    return "";
  }

  String getSignInScreenSwitchRegisterText1(String language) {
    if (language == 'en') {
      return "Already have an Account ? ";
    } else if (language == "hi") {
      return "क्या आपके पास पहले से एक खाता मौजूद है ?";
    }

    return "Already have an Account ? ";
  }

  String getSignInScreenSwitchRegisterText2(String language) {
    if (language == 'en') {
      return "Login";
    } else if (language == "hi") {
      return "लॉग इन करें";
    }

    return "";
  }

  String getSignInScreenCopyRightText(String language) {
    if (language == 'en') {
      return "© 2023 Copyright by Bible GPT";
    } else if (language == "hi") {
      return "© 2023 कॉपीराइट बाइबिल जीपीटी द्वारा";
    }
    return "";
  }

  String getSignInScreenGoogleContentText(String language) {
    if (language == 'en') {
      return "or login with";
    } else if (language == "hi") {
      return "या के साथ लॉगिन करें";
    }

    return "";
  }

  String getSignInScreenNumberButtonText(String language) {
    if (language == 'en') {
      return "By Phone number";
    } else if (language == "hi") {
      return "फ़ोन नंबर द्वारा";
    }
    return "";
  }

  String getSignInScreenEmailButtonText(String language) {
    if (language == 'en') {
      return "By Email";
    } else if (language == "hi") {
      return "ईमेल द्वारा";
    }
    return "";
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
  String getNoInternetScreenTitleText(String language) {
    if (language == "en") {
      return "NO INTERNET CONNECTION";
    } else if (language == 'hi') {
      return "कोई इंटरनेट कनेक्शन नहीं";
    }
    return "";
  }

  String getNoInternetScreenContentText(String language) {
    if (language == 'en') {
      return "There was a problem connecting to the internet. Please hit Retry to connect again";
    } else if (language == 'hi') {
      return "इंटरनेट से कनेक्ट होने में समस्या थी. कृपया पुनः कनेक्ट करने के लिए पुनः प्रयास करें दबाएँ";
    }
    return "";
  }

  String getNoInternetScreenRetryButtonText(String language) {
    if (language == 'en') {
      return "RETRY";
    } else if (language == 'hi') {
      return "पुन: प्रयास";
    }
    return "";
  }

  String oldTestament = "Old Testament";

  String bottomNavOldTestment(String language) {
    if (language == 'en') {
      return 'Old Testament';
    } else if (language == 'hi') {
      return 'पुराना वसीयतनामा';
    }
    return '';
  }

  String bottomNavNewTestment(String language) {
    if (language == 'en') {
      return 'New Testament';
    } else if (language == 'hi') {
      return 'नया करार';
    }
    return '';
  }

  String theBookOf = " The Book Of";
  String bible = "Bible";

  String bottomNavLanguageDropDown(String language) {
    if (language == 'en') {
      return 'Language';
    } else if (language == 'hi') {
      return 'भाषा';
    }
    return '';
  }

  String bottomNavEditionDropDown(String language) {
    if (language == 'en') {
      return 'Trasilations/Editions';
    } else if (language == 'hi') {
      return 'अनुवाद/संस्करण';
    }
    return '';
  }

  String bottomNavAll(String language) {
    if (language == 'en') {
      return 'All';
    } else if (language == 'hi') {
      return 'सभी';
    }
    return '';
  }
}
