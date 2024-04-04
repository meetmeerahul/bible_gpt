import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../class/LanguageMethod.dart';
import '../class/country_class.dart';
import '../class/google_auth.dart';
import '../class/theme_method.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';
import '../reuseable/button/BackArrowWidget.dart';
import '../reuseable/button/GoogleButton.dart';
import '../reuseable/button/PrimaryButton.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/background_color_widget.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/login_textfield_widget.dart';

import '../widgets/toast_message.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  double scaleFactor = 0;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool activeMail = true;
  bool showPassword = true;
  bool showConfirmPassword = true;
  bool logInScreen = true;
  late bool darkMode;
  CountryClass? selectedCountry;
  List<CountryClass> countryList = [];

  //String copyRightContentTextFutureMethod = "© 2023 Copyright by Bible GPT";

  late String getLanguageCode;

  ScrollController pageScrollController = ScrollController();
  double statusBarHeight = 0;
  bool statusBarVisible = false;
  bool isAPILoading = false;

  navigateToNoInternetScreen(bool callInit) {
    // Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => NoInternetScreen()))
    //     .then((value) {
    //   if (callInit) {
    //     callInitState();
    //   }
    // });
  }

  bool nameValidation(String getName) {
    return (getName.length > 1 && getName.length < 101) ? true : false;
  }

  bool mailIdValidation(String getMailId) {
    return (getMailId.length > 4 && getMailId.length < 101)
        ? isEmailValid(getMailId)
        : false;
  }

  bool mobileNumberValidation(String getMobileNumber) {
    return (getMobileNumber.length > 4 && getMobileNumber.length < 101)
        ? isMobileNumberValid(getMobileNumber)
        : false;
  }

  bool passwordValidation(String getPassword) {
    return (getPassword.length > 5 && getPassword.length < 101) ? true : false;
  }

  bool isEmailValid(String getMailId) {
    //String option1 = "^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    //String option2 = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(getMailId);
    return emailValid;
  }

  bool isMobileNumberValid(String getMobileNumber) {
    print(getMobileNumber);
    bool isValidPhoneNumber =
        RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
            .hasMatch(getMobileNumber);
    return isValidPhoneNumber;
  }

  Future<void> readJson() async {
    final String response = await rootBundle
        .loadString(AppConfig().signInScreenCountryCodeJsonFile);
    List countryCodeData = await json.decode(response);
    setState(() {
      countryList.clear();
      for (int i = 0; i < countryCodeData.length; i++) {
        print(countryCodeData[i]);
        Map getCountryMap = countryCodeData[i] ?? {};
        if (getCountryMap.isNotEmpty) {
          String getCountryName = getCountryMap["name"] ?? "";
          String getCountryDialCode = getCountryMap["dial_code"] ?? "";
          String getCountryCode = getCountryMap["code"] ?? "";
          countryList.add(CountryClass(
              countryId: i,
              countryName: getCountryName,
              countryDialCode: getCountryDialCode,
              countryCode: getCountryCode,
              mobileNumberLength: 10));
        }
      }
      selectedCountry = countryList.isNotEmpty ? countryList[0] : null;
    });
  }

  resetControl() {
    setState(() {
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();
      mobileNumberController.clear();
      confirmPasswordController.clear();
      showPassword = true;
      showConfirmPassword = true;
    });
    //futureFunctionMethod();
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      readJson();
      // futureFunctionMethod();
      pageScrollController.addListener(() {
        if (pageScrollController.offset > 0) {
          if (statusBarVisible) {
          } else {
            setState(() {
              statusBarVisible = true;
            });
          }
        } else {
          setState(() {
            statusBarVisible = false;
          });
        }
      });
    } else {
      navigateToNoInternetScreen(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callInitState();
  }

  @override
  void dispose() {
    pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    darkMode = themeMethod(context);

    getLanguageCode = languageMethod(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BackgroundColorWidget(
              context: context,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              getDarkMode: darkMode,
              getLanguageCode: getLanguageCode,
              imageWidget: true,
              imageWidth: 400,
              imageHeight: 280,
              bottomImagePadding: 30,
              bottomCopyRightsContentPadding: 34,
              imageContentFuture: "",
            ),
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: SingleChildScrollView(
                controller: pageScrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight *
                                (AppConfig().signInScreenTopBackButtonPadding /
                                    AppConfig().screenHeight),
                          ),
                          Container(
                            width: screenWidth,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth *
                                    (24 / AppConfig().screenWidth)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: BackArrowWidget(
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      darkMode: darkMode,
                                      getCallBackFunction:
                                          (getCallBackFunction) {
                                        if (getCallBackFunction) {
                                          Navigator.pop(context);
                                        }
                                      }),
                                ),
                                AppLogoWidget(
                                    screenWidth,
                                    screenHeight,
                                    AppConfig().signInScreenAppLogoWidth,
                                    AppConfig().signInScreenAppLogoHeight,
                                    darkMode),
                                Container(
                                  width: screenWidth *
                                      ((AppConfig().backArrowWidgetOuterWidth) /
                                          AppConfig().screenWidth),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight *
                                ((logInScreen ? 80 : 40) /
                                    AppConfig().screenHeight),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth *
                              (AppConfig().signInScreenLeftPadding /
                                  AppConfig().screenWidth)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          activeMail
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenHeight *
                                            (AppConfig()
                                                    .signInScreenActiveButtonRadius /
                                                AppConfig().screenHeight))),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        AppConfig()
                                            .signInScreenActiveButtonBackgroundStartColor
                                            .withOpacity(0.8),
                                        AppConfig()
                                            .signInScreenActiveButtonBackgroundEndColor
                                            .withOpacity(0.8),
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth *
                                            (45 / AppConfig().screenWidth),
                                        vertical: screenHeight *
                                            (AppConfig()
                                                    .signInScreenActiveInnerButtonVerticalPadding /
                                                AppConfig().screenHeight)),
                                    // child: languageFutureWidget(
                                    //     screenWidth: screenWidth,
                                    //     screenHeight: screenHeight,
                                    //     selectedLanguage: getLanguageCode,
                                    //     getLanguageTranslatorMethod:
                                    //         emailButtonTextFutureMethod,
                                    //     getFontSize: AppConfig()
                                    //         .signInScreenActiveButtonTextSize,
                                    //     getDarkMode: darkMode,
                                    //     getTextAlign: TextAlign.center,
                                    //     getTextColor: AppConfig()
                                    //         .signInScreenActiveButtonTextColor,
                                    //     getFontFamily:
                                    //         AppConfig().outfitFontRegular,
                                    //     getTextDirection: LanguageTextFile()
                                    //         .getTextDirection(getLanguageCode),
                                    //     getSoftWrap: true),
                                    child: Text(
                                      LanguageTextFile()
                                          .getSignInScreenEmailButtonText(
                                              getLanguageCode),
                                      textScaler: const TextScaler.linear(1.0),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .textScaler
                                              .scale(screenHeight *
                                                  (AppConfig()
                                                          .signInScreenActiveButtonTextSize /
                                                      AppConfig()
                                                          .screenHeight)),
                                          color: AppConfig()
                                              .signInScreenActiveButtonTextColor,
                                          fontFamily:
                                              AppConfig().outfitFontRegular),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: TextButton(
                                    onPressed: () {
                                      resetControl();
                                      setState(() {
                                        activeMail = true;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    // child: languageFutureWidget(
                                    //     screenWidth: screenWidth,
                                    //     screenHeight: screenHeight,
                                    //     selectedLanguage: getLanguageCode,
                                    //     getLanguageTranslatorMethod:
                                    //         emailButtonTextFutureMethod,
                                    //     getFontSize: AppConfig()
                                    //         .signInScreenInActiveButtonTextSize,
                                    //     getDarkMode: darkMode,
                                    //     getTextAlign: TextAlign.end,
                                    //     getTextColor: darkMode
                                    //         ? AppConfig()
                                    //             .signInScreenInActiveTextDarkColor
                                    //         : AppConfig()
                                    //             .signInScreenInActiveTextLightColor,
                                    //     getFontFamily:
                                    //         AppConfig().outfitFontRegular,
                                    //     getTextDirection: LanguageTextFile()
                                    //         .getTextDirection(getLanguageCode),
                                    //     getSoftWrap: true),
                                    child: Text(
                                      LanguageTextFile()
                                          .getSignInScreenEmailButtonText(
                                              getLanguageCode),
                                      textScaler: const TextScaler.linear(1.0),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .textScaler
                                              .scale(screenHeight *
                                                  (AppConfig()
                                                          .signInScreenActiveButtonTextSize /
                                                      AppConfig()
                                                          .screenHeight)),
                                          color: darkMode
                                              ? AppConfig()
                                                  .signInScreenInActiveTextDarkColor
                                              : AppConfig()
                                                  .signInScreenInActiveTextLightColor,
                                          fontFamily:
                                              AppConfig().outfitFontRegular),
                                    ),
                                  ),
                                ),
                          activeMail
                              ? Container(
                                  child: TextButton(
                                    onPressed: () {
                                      if (isAPILoading) {
                                      } else {
                                        resetControl();
                                        setState(() {
                                          activeMail = false;
                                        });
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    // child:
                                    //   languageFutureWidget(
                                    //       screenWidth: screenWidth,
                                    //       screenHeight: screenHeight,
                                    //       selectedLanguage: getLanguageCode,
                                    //       getLanguageTranslatorMethod:
                                    //           numberButtonTextFutureMethod,
                                    //       getFontSize: AppConfig()
                                    //           .signInScreenInActiveButtonTextSize,
                                    //       getDarkMode: darkMode,
                                    //       getTextAlign: TextAlign.end,
                                    //       getTextColor: darkMode
                                    //           ? AppConfig()
                                    //               .signInScreenInActiveTextDarkColor
                                    //           : AppConfig()
                                    //               .signInScreenInActiveTextLightColor,
                                    //       getFontFamily:
                                    //           AppConfig().outfitFontRegular,
                                    //       getTextDirection: LanguageTextFile()
                                    //           .getTextDirection(getLanguageCode),
                                    //       getSoftWrap: true),
                                    child: Text(
                                      LanguageTextFile()
                                          .getSignInScreenNumberButtonText(
                                              getLanguageCode),
                                      textScaler: const TextScaler.linear(1.0),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .textScaler
                                              .scale(screenHeight *
                                                  (AppConfig()
                                                          .signInScreenActiveButtonTextSize /
                                                      AppConfig()
                                                          .screenHeight)),
                                          color: darkMode
                                              ? AppConfig()
                                                  .signInScreenInActiveTextDarkColor
                                              : AppConfig()
                                                  .signInScreenInActiveTextLightColor,
                                          fontFamily:
                                              AppConfig().outfitFontRegular),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenHeight *
                                            (AppConfig()
                                                    .signInScreenActiveButtonRadius /
                                                AppConfig().screenHeight))),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        AppConfig()
                                            .signInScreenActiveButtonBackgroundStartColor
                                            .withOpacity(0.8),
                                        AppConfig()
                                            .signInScreenActiveButtonBackgroundEndColor
                                            .withOpacity(0.8),
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth *
                                            (40 / AppConfig().screenWidth),
                                        vertical: screenHeight *
                                            (AppConfig()
                                                    .signInScreenActiveInnerButtonVerticalPadding /
                                                AppConfig().screenHeight)),
                                    // child: languageFutureWidget(
                                    //     screenWidth: screenWidth,
                                    //     screenHeight: screenHeight,
                                    //     selectedLanguage: getLanguageCode,
                                    //     getLanguageTranslatorMethod:
                                    //         numberButtonTextFutureMethod,
                                    //     getFontSize: AppConfig()
                                    //         .signInScreenActiveButtonTextSize,
                                    //     getDarkMode: darkMode,
                                    //     getTextAlign: TextAlign.center,
                                    //     getTextColor: AppConfig()
                                    //         .signInScreenActiveButtonTextColor,
                                    //     getFontFamily:
                                    //         AppConfig().outfitFontRegular,
                                    //     getTextDirection: LanguageTextFile()
                                    //         .getTextDirection(getLanguageCode),
                                    //     getSoftWrap: true),
                                    child: Text(
                                      LanguageTextFile()
                                          .getSignInScreenNumberButtonText(
                                              getLanguageCode),
                                      textScaler: const TextScaler.linear(1.0),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .textScaler
                                              .scale(screenHeight *
                                                  (AppConfig()
                                                          .signInScreenActiveButtonTextSize /
                                                      AppConfig()
                                                          .screenHeight)),
                                          color: AppConfig()
                                              .signInScreenActiveButtonTextColor,
                                          fontFamily:
                                              AppConfig().outfitFontRegular),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight *
                          (AppConfig().signInScreenBottomMailButtonPadding /
                              AppConfig().screenHeight),
                    ),
                    logInScreen
                        ? const SizedBox()
                        : LogInTextFieldWidget(
                            context,
                            screenWidth,
                            screenHeight,
                            scaleFactor,
                            AppConfig().logInWidgetEdittextWidth,
                            AppConfig().logInWidgetEdittextHeight,
                            firstNameController,
                            false,
                            false,
                            LanguageTextFile().getSignInScreenFirstNameHintText(
                                getLanguageCode),
                            TextInputAction.next,
                            TextInputType.name,
                            darkMode,
                            "en",
                            isAPILoading ? true : false,
                            (getFirstName) {},
                            (getSelected) {}),
                    logInScreen
                        ? const SizedBox()
                        : SizedBox(
                            height: screenHeight *
                                (AppConfig().signInScreenEdittextPadding /
                                    AppConfig().screenHeight),
                          ),
                    logInScreen
                        ? const SizedBox()
                        : LogInTextFieldWidget(
                            context,
                            screenWidth,
                            screenHeight,
                            scaleFactor,
                            AppConfig().logInWidgetEdittextWidth,
                            AppConfig().logInWidgetEdittextHeight,
                            lastNameController,
                            false,
                            false,
                            LanguageTextFile().getSignInScreenLastNameHintText(
                                getLanguageCode),
                            TextInputAction.next,
                            TextInputType.name,
                            darkMode,
                            "en",
                            isAPILoading ? true : false,
                            (getPassword) {},
                            (getSelected) {}),
                    logInScreen
                        ? const SizedBox()
                        : SizedBox(
                            height: screenHeight *
                                (AppConfig().signInScreenEdittextPadding /
                                    AppConfig().screenHeight),
                          ),
                    activeMail
                        ? LogInTextFieldWidget(
                            context,
                            screenWidth,
                            screenHeight,
                            scaleFactor,
                            AppConfig().logInWidgetEdittextWidth,
                            AppConfig().logInWidgetEdittextHeight,
                            emailController,
                            false,
                            false,
                            LanguageTextFile()
                                .getSignInScreenEmailHintText(getLanguageCode),
                            TextInputAction.next,
                            TextInputType.emailAddress,
                            darkMode,
                            "en",
                            isAPILoading ? true : false,
                            (getText) {},
                            (getSelected) {},
                          )
                        : SizedBox(
                            width: screenWidth -
                                screenWidth *
                                    (AppConfig().signInScreenLeftPadding *
                                        2 /
                                        AppConfig().screenWidth),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  width: screenWidth -
                                      screenWidth *
                                          (AppConfig().signInScreenLeftPadding *
                                              2 /
                                              AppConfig().screenWidth),
                                  alignment: Alignment.centerLeft,
                                  child: DropdownButton<CountryClass>(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth *
                                            (0 / AppConfig().screenWidth)),
                                    // Initial Valu
                                    value: null,
                                    hint: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // child: TextWidget(
                                          //     screenWidth: screenWidth,
                                          //     screenHeight: screenHeight,
                                          //     getText:
                                          //         "${selectedCountry == null ? "+00" : selectedCountry?.countryDialCode}",
                                          //     fontSize: 12,
                                          //     getTextAlign: TextAlign.center,
                                          //     getTextColor: darkMode
                                          //         ? AppConfig()
                                          //             .signInScreenLogInTextDarkColor
                                          //         : AppConfig()
                                          //             .signInScreenLogInTextLightColor,
                                          //     getFontFamily: AppConfig()
                                          //         .outfitFontSemiBold,
                                          //     getSoftWrap: true),
                                          //child: languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getLanguageCode,getLanguageTranslatorMethod: countryCodeTextFutureMethod, getFontSize: 12, getDarkMode: darkMode, getTextAlign: TextAlign.center, getTextColor: darkMode?AppConfig().signInScreenLogInTextDarkColor:AppConfig().signInScreenLogInTextLightColor, getFontFamily: AppConfig().outfitFontSemiBold, getTextDirection: LanguageTextFile().getTextDirection(getLanguageCode), getSoftWrap: true),
                                          child: Text(
                                            "${selectedCountry == null ? "+00" : selectedCountry?.countryDialCode}",
                                            textScaler:
                                                const TextScaler.linear(1.0),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: screenHeight *
                                                    (12 /
                                                        AppConfig()
                                                            .screenHeight),
                                                color: darkMode
                                                    ? AppConfig()
                                                        .signInScreenLogInTextDarkColor
                                                    : AppConfig()
                                                        .signInScreenLogInTextLightColor,
                                                fontFamily: AppConfig()
                                                    .outfitFontSemiBold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth *
                                              (11 / AppConfig().screenWidth),
                                        ),
                                        SizedBox(
                                          width: screenWidth *
                                              (14 / AppConfig().screenWidth),
                                          child: SvgPicture.asset(
                                            AppConfig()
                                                .signInScreenDropdownIcon,
                                            fit: BoxFit.fitWidth,
                                            color: darkMode
                                                ? AppConfig()
                                                    .signInScreenDropDownIconDarkColor
                                                : AppConfig()
                                                    .signInScreenDropDownIconLightColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth *
                                              (16 / AppConfig().screenWidth),
                                        ),
                                      ],
                                    ),
                                    isExpanded: true,
                                    icon: null,
                                    iconSize: 0,
                                    underline: const SizedBox(),
                                    dropdownColor: darkMode
                                        ? const Color(0xFF2D281E)
                                        : const Color(0xFFFFFFFF),
                                    items: countryList
                                        .map((CountryClass getCountryItem) {
                                      return DropdownMenuItem(
                                        value: getCountryItem,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // child: languageFutureWidget(
                                                //     screenWidth: screenWidth,
                                                //     screenHeight: screenHeight,
                                                //     selectedLanguage:
                                                //         getLanguageCode,
                                                //     getLanguageTranslatorMethod:
                                                //         languageTranslatorMethod(
                                                //             getText:
                                                //                 "${getCountryItem.countryDialCode}(${getCountryItem.countryCode})",
                                                //             getLanguageCode:
                                                //                 getLanguageCode),
                                                //     getFontSize: 12,
                                                //     getDarkMode: darkMode,
                                                //     getTextAlign:
                                                //         TextAlign.center,
                                                //     getTextColor: darkMode
                                                //         ? AppConfig()
                                                //             .signInScreenLogInTextDarkColor
                                                //         : AppConfig()
                                                //             .signInScreenLogInTextLightColor,
                                                //     getFontFamily: AppConfig()
                                                //         .outfitFontSemiBold,
                                                //     getTextDirection:
                                                //         LanguageTextFile()
                                                //             .getTextDirection(
                                                //                 getLanguageCode),
                                                //     getSoftWrap: true),
                                                child: Text(
                                                  "${getCountryItem.countryDialCode}(${getCountryItem.countryCode})",
                                                  textScaler:
                                                      const TextScaler.linear(
                                                          1.0),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: screenHeight *
                                                          (12 /
                                                              AppConfig()
                                                                  .screenHeight),
                                                      color: darkMode
                                                          ? AppConfig()
                                                              .signInScreenLogInTextDarkColor
                                                          : AppConfig()
                                                              .signInScreenLogInTextLightColor,
                                                      fontFamily: AppConfig()
                                                          .outfitFontSemiBold),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth *
                                                    (11 /
                                                        AppConfig()
                                                            .screenWidth),
                                              ),
                                              Container(
                                                // child: languageFutureWidget(
                                                //     screenWidth: screenWidth,
                                                //     screenHeight: screenHeight,
                                                //     selectedLanguage:
                                                //         getLanguageCode,
                                                //     getLanguageTranslatorMethod:
                                                //         languageTranslatorMethod(
                                                //             getText:
                                                //                 getCountryItem
                                                //                     .countryName,
                                                //             getLanguageCode:
                                                //                 getLanguageCode),
                                                //     getFontSize: 10,
                                                //     getDarkMode: darkMode,
                                                //     getTextAlign:
                                                //         TextAlign.center,
                                                //     getTextColor: darkMode
                                                //         ? AppConfig()
                                                //             .signInScreenLogInTextDarkColor
                                                //         : AppConfig()
                                                //             .signInScreenLogInTextLightColor,
                                                //     getFontFamily: AppConfig()
                                                //         .outfitFontMedium,
                                                //     getTextDirection:
                                                //         LanguageTextFile()
                                                //             .getTextDirection(
                                                //                 getLanguageCode),
                                                //     getSoftWrap: true),
                                                child: Text(
                                                  getCountryItem.countryName,
                                                  textScaler:
                                                      const TextScaler.linear(
                                                          1.0),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: screenHeight *
                                                          (10 /
                                                              AppConfig()
                                                                  .screenHeight),
                                                      color: darkMode
                                                          ? AppConfig()
                                                              .signInScreenLogInTextDarkColor
                                                          : AppConfig()
                                                              .signInScreenLogInTextLightColor,
                                                      fontFamily: AppConfig()
                                                          .outfitFontMedium),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (CountryClass? countryValue) {
                                      setState(() {
                                        selectedCountry = countryValue;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: screenWidth -
                                      screenWidth *
                                          ((AppConfig()
                                                      .signInScreenLeftPadding +
                                                  AppConfig()
                                                      .signInScreenLeftPadding +
                                                  46 +
                                                  11 +
                                                  14 +
                                                  16) /
                                              AppConfig().screenWidth),
                                  child: LogInTextFieldWidget(
                                    context,
                                    screenWidth,
                                    screenHeight,
                                    scaleFactor,
                                    screenWidth,
                                    AppConfig().logInWidgetEdittextHeight,
                                    mobileNumberController,
                                    false,
                                    false,
                                    LanguageTextFile()
                                        .getSignInScreenNumberHintText(
                                            getLanguageCode),
                                    TextInputAction.next,
                                    TextInputType.number,
                                    darkMode,
                                    "en",
                                    isAPILoading ? true : false,
                                    (getText) {},
                                    (getSelected) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: screenHeight *
                          (AppConfig().signInScreenEdittextPadding /
                              AppConfig().screenHeight),
                    ),
                    LogInTextFieldWidget(
                        context,
                        screenWidth,
                        screenHeight,
                        scaleFactor,
                        AppConfig().logInWidgetEdittextWidth,
                        AppConfig().logInWidgetEdittextHeight,
                        passwordController,
                        true,
                        showPassword,
                        LanguageTextFile()
                            .getSignInScreenPasswordHintText(getLanguageCode),
                        logInScreen
                            ? TextInputAction.done
                            : TextInputAction.next,
                        TextInputType.visiblePassword,
                        darkMode,
                        "en",
                        isAPILoading ? true : false, (getPassword) {
                      // setState(() {
                      //   passwordController.text = getPassword;
                      // });
                    }, (getSelected) {
                      setState(() {
                        showPassword = getSelected;
                      });
                    }),
                    logInScreen
                        ? const SizedBox()
                        : SizedBox(
                            height: screenHeight *
                                (AppConfig().signInScreenEdittextPadding /
                                    AppConfig().screenHeight),
                          ),
                    logInScreen
                        ? const SizedBox()
                        : LogInTextFieldWidget(
                            context,
                            screenWidth,
                            screenHeight,
                            scaleFactor,
                            AppConfig().logInWidgetEdittextWidth,
                            AppConfig().logInWidgetEdittextHeight,
                            confirmPasswordController,
                            true,
                            showConfirmPassword,
                            LanguageTextFile()
                                .getSignInScreenConfirmPasswordHintText(
                                    getLanguageCode),
                            TextInputAction.done,
                            TextInputType.visiblePassword,
                            darkMode,
                            "en",
                            isAPILoading ? true : false,
                            (getText) {
                              // setState(() {
                              //   confirmPasswordController.text = getText;
                              // });
                            },
                            (getSelected) {
                              setState(() {
                                showConfirmPassword = getSelected;
                              });
                            },
                          ),
                    SizedBox(
                      height: screenHeight *
                          (AppConfig().signInScreenBottomEdittextPadding /
                              AppConfig().screenHeight),
                    ),
                    /*logInScreen?Container(
                          width: screenWidth*(AppConfig().logInWidgetEdittextWidth/AppConfig().screenWidth),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: (){
                              if(isAPILoading){

                              }
                              else{
                                navigateToForgetPasswordScreen();
                              }
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getLanguageCode,getLanguageTranslatorMethod:forgetPasswordTextFutureMethod, getFontSize: AppConfig().signInScreenInActiveButtonTextSize, getDarkMode: darkMode, getTextAlign: TextAlign.end, getTextColor: Color(0xFFE05624), getFontFamily: AppConfig().outfitFontRegular, getTextDirection: LanguageTextFile().getTextDirection(getLanguageCode), getSoftWrap:true),
                            //child: Text("Forgot password",textScaler: TextScaler.linear(1.0),textAlign: TextAlign.end,style: TextStyle(fontSize: screenHeight*(AppConfig().signInScreenInActiveButtonTextSize/AppConfig().screenHeight),color: Color(0xFFE05624),fontFamily: AppConfig().outfitFontRegular),textDirection: LanguageTextFile().getTextDirection(getLanguageCode),),
                          ),
                        ):SizedBox(),*/
                    SizedBox(
                      height: screenHeight *
                          (AppConfig().signInScreenBottomEdittextPadding *
                              2 /
                              AppConfig().screenHeight),
                    ),
                    PrimaryButton(
                        context: context,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        buttonWidth: AppConfig().signInScreenButtonWidth,
                        buttonHeight: AppConfig().signInScreenButtonHeight,
                        getDarkMode: false,
                        buttonText: logInScreen
                            ? LanguageTextFile()
                                .getSignInScreenLogInButtonText(getLanguageCode)
                            : LanguageTextFile()
                                .getSignInScreenRegisterButtonText(
                                    getLanguageCode),
                        getLanguageCode: "en",
                        isAPILoading: isAPILoading,
                        iconPath: null,
                        iconWidth: null,
                        iconHeight: null,
                        buttonPressedFunction: (isClicked) {
                          print("2");
                          if (isAPILoading) {
                          } else {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (activeMail) {
                              if (logInScreen) {
                                if (mailIdValidation(
                                        emailController.text.toString()) &&
                                    passwordValidation(
                                        passwordController.text.toString())) {
                                  print("success");
                                  print(
                                      "mail Id : ${emailController.text.toString()}");
                                  print(
                                      "password : ${passwordController.text.toString()}");
                                  // callLogInAPI(emailController.text.toString(),
                                  // passwordController.text.toString());
                                } else {
                                  if (!mailIdValidation(
                                      emailController.text.toString())) {
                                    ToastMessage(screenHeight,
                                        "Email Id is not valid", false);
                                  } else {
                                    ToastMessage(
                                        screenHeight,
                                        "Password must atleast 6 character",
                                        false);
                                  }
                                }
                              } else {
                                if (nameValidation(
                                        firstNameController.text.toString()) &&
                                    nameValidation(
                                        lastNameController.text.toString()) &&
                                    mailIdValidation(
                                        emailController.text.toString()) &&
                                    passwordValidation(
                                        passwordController.text.toString()) &&
                                    passwordValidation(confirmPasswordController
                                        .text
                                        .toString()) &&
                                    (passwordController.text ==
                                        confirmPasswordController.text)) {
                                  print("success");
                                  print(
                                      "first name : ${firstNameController.text.toString()}");
                                  print(
                                      "last name : ${lastNameController.text.toString()}");
                                  print(
                                      "mail Id : ${emailController.text.toString()}");
                                  print(
                                      "password : ${passwordController.text.toString()}");
                                  // callRegisterAPI(
                                  //     firstNameController.text.toString(),
                                  //     lastNameController.text.toString(),
                                  //     emailController.text.toString(),
                                  //     passwordController.text.toString());
                                } else {
                                  if (!nameValidation(
                                      firstNameController.text.toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "First Name must atleast 2 character",
                                        false);
                                  } else if (!nameValidation(
                                      lastNameController.text.toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "Last Name must atleast 2 character",
                                        false);
                                  } else if (!mailIdValidation(
                                      emailController.text.toString())) {
                                    ToastMessage(screenHeight,
                                        "Email Id is not valid", false);
                                  } else if (!passwordValidation(
                                      passwordController.text.toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "Password must atleast 6 character",
                                        false);
                                  } else if (!passwordValidation(
                                      confirmPasswordController.text
                                          .toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "Confirm Password must atleast 6 character",
                                        false);
                                  } else if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    ToastMessage(
                                        screenHeight,
                                        "Confirm Password not matched with Password",
                                        false);
                                  }
                                }
                              }
                            } else {
                              if (logInScreen) {
                                if (mobileNumberValidation(
                                        "${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}") &&
                                    passwordValidation(
                                        passwordController.text.toString())) {
                                  print("success");
                                  print(
                                      "mobile number ${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}");
                                  print(
                                      "password : ${passwordController.text.toString()}");
                                  // callLogInAPI(
                                  //     "${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}",
                                  //     passwordController.text.toString());
                                } else {
                                  if (!mobileNumberValidation(
                                      "${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}")) {
                                    ToastMessage(screenHeight,
                                        "Mobile Number is not valid", false);
                                  } else {
                                    ToastMessage(
                                        screenHeight,
                                        "Password must atleast 6 character",
                                        false);
                                  }
                                }
                              } else {
                                if (nameValidation(
                                        firstNameController.text.toString()) &&
                                    nameValidation(
                                        lastNameController.text.toString()) &&
                                    mobileNumberValidation(
                                        "${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}") &&
                                    passwordValidation(
                                        passwordController.text.toString()) &&
                                    passwordValidation(confirmPasswordController
                                        .text
                                        .toString()) &&
                                    (passwordController.text ==
                                        confirmPasswordController.text)) {
                                  print("success");
                                  print(
                                      "first name : ${firstNameController.text.toString()}");
                                  print(
                                      "last name : ${lastNameController.text.toString()}");
                                  print(
                                      "mobile number ${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}");
                                  print(
                                      "password : ${passwordController.text.toString()}");
                                  // callRegisterAPI(
                                  //     firstNameController.text.toString(),
                                  //     lastNameController.text.toString(),
                                  //     "${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}",
                                  //     passwordController.text.toString());
                                } else {
                                  if (!nameValidation(
                                      firstNameController.text.toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "First Name must atleast 2 character",
                                        false);
                                  } else if (!nameValidation(
                                      lastNameController.text.toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "Last Name must atleast 2 character",
                                        false);
                                  } else if (!mobileNumberValidation(
                                      "${selectedCountry?.countryDialCode.replaceAll("+", "")}${mobileNumberController.text.toString()}")) {
                                    ToastMessage(screenHeight,
                                        "Mobile Number is not valid", false);
                                  } else if (!passwordValidation(
                                      passwordController.text.toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "Password must atleast 6 character",
                                        false);
                                  } else if (!passwordValidation(
                                      confirmPasswordController.text
                                          .toString())) {
                                    ToastMessage(
                                        screenHeight,
                                        "Confirm Password must atleast 6 character",
                                        false);
                                  } else if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    ToastMessage(
                                        screenHeight,
                                        "Confirm Password not matched with Password",
                                        false);
                                  }
                                }
                              }
                            }
                          }
                        }),
                    SizedBox(
                      height: screenHeight *
                          (AppConfig().signInScreenBottomButtonPadding /
                              AppConfig().screenHeight),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth *
                                (AppConfig().signInScreenBorderLineWidth /
                                    AppConfig().screenWidth),
                            height: screenHeight *
                                (AppConfig().signInScreenBorderLineHeight /
                                    AppConfig().screenHeight),
                            color: darkMode
                                ? AppConfig().signInScreenBorderDarkColor
                                : AppConfig().signInScreenBorderLightColor,
                          ),
                          SizedBox(
                            width: screenWidth *
                                (AppConfig().signInScreenBorderTextPadding /
                                    AppConfig().screenWidth),
                          ),
                          Container(
                            // child: languageFutureWidget(
                            //     screenWidth: screenWidth,
                            //     screenHeight: screenHeight,
                            //     selectedLanguage: getLanguageCode,
                            //     getLanguageTranslatorMethod:
                            //         googleContentTextFutureMethod,
                            //     getFontSize:
                            //         AppConfig().signInScreenLogInTextSize,
                            //     getDarkMode: darkMode,
                            //     getTextAlign: TextAlign.center,
                            //     getTextColor: darkMode
                            //         ? AppConfig().signInScreenLogInTextDarkColor
                            //         : AppConfig()
                            //             .signInScreenLogInTextLightColor,
                            //     getFontFamily: AppConfig().outfitFontRegular,
                            //     getTextDirection: LanguageTextFile()
                            //         .getTextDirection(getLanguageCode),
                            //     getSoftWrap: true),
                            child: Text(
                              LanguageTextFile()
                                  .getSignInScreenGoogleContentText(
                                      getLanguageCode),
                              textScaler: const TextScaler.linear(1.0),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(
                                          context)
                                      .textScaler
                                      .scale(screenHeight *
                                          (AppConfig()
                                                  .signInScreenLogInTextSize /
                                              AppConfig().screenHeight)),
                                  color:
                                      darkMode
                                          ? AppConfig()
                                              .signInScreenLogInTextDarkColor
                                          : AppConfig()
                                              .signInScreenLogInTextLightColor,
                                  fontFamily: AppConfig().outfitFontRegular),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth *
                                (AppConfig().signInScreenBorderTextPadding /
                                    AppConfig().screenWidth),
                          ),
                          Container(
                            width: screenWidth *
                                (AppConfig().signInScreenBorderLineWidth /
                                    AppConfig().screenWidth),
                            height: screenHeight *
                                (AppConfig().signInScreenBorderLineHeight /
                                    AppConfig().screenHeight),
                            color: darkMode
                                ? AppConfig().signInScreenBorderDarkColor
                                : AppConfig().signInScreenBorderLightColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight *
                          (AppConfig().signInScreenBottomButtonPadding /
                              AppConfig().screenHeight),
                    ),
                    /*  Platform.isIOS
                        ? AppleButton(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            buttonWidth:
                                AppConfig().signInScreenAppleButtonWidth,
                            buttonHeight:
                                AppConfig().signInScreenAppleButtonHeight,
                            buttonTextFunction: appleButtonTextFutureMethod!,
                            getLanguageCode: getLanguageCode,
                            isAPILoading: isAPILoading,
                            buttonPressedFunction: (isClick) {
                              if (isClick) {
                                if (isAPILoading) {
                                } else {
                                  print("Apple click");
                                  appleClick();
                                }
                              }
                            })
                        : const SizedBox(),
                    Platform.isIOS
                        ? SizedBox(
                            height: screenHeight *
                                (AppConfig().signInScreenBottomButtonPadding /
                                    AppConfig().screenHeight),
                          )
                        : const SizedBox(),
                        */
                    GoogleButton(
                        context: context,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        buttonWidth: AppConfig().signInScreenGoogleButtonWidth,
                        buttonHeight:
                            AppConfig().signInScreenGoogleButtonHeight,
                        buttonText: logInScreen
                            ? LanguageTextFile()
                                .getSignInScreenLogInGoogleButtonText(
                                    getLanguageCode)
                            : LanguageTextFile()
                                .getSignInScreenRegisterGoogleButtonText(
                                    getLanguageCode),
                        getLanguageCode: "en",
                        isAPILoading: isAPILoading,
                        buttonPressedFunction: (isClick) {
                          if (isClick) {
                            if (isAPILoading) {
                            } else {
                              print("Google clicked");
                              googleClick();
                            }
                          }
                        }),
                    SizedBox(
                      height: screenHeight *
                          (AppConfig().signInScreenBottomButtonPadding /
                              AppConfig().screenHeight),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth *
                              (AppConfig().signInScreenLeftPadding /
                                  AppConfig().screenWidth)),
                      child: TextButton(
                        onPressed: () {
                          if (isAPILoading) {
                          } else {
                            setState(() {
                              if (logInScreen) {
                                logInScreen = false;
                              } else {
                                logInScreen = true;
                              }
                              resetControl();
                              print(logInScreen);
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // textDirection: LanguageTextFile()
                          //     .getTextDirection(getLanguageCode),
                          children: [
                            Container(
                              child: Text(
                                logInScreen
                                    ? LanguageTextFile()
                                        .getSignInScreenSwitchLogInText1(
                                            getLanguageCode)
                                    : LanguageTextFile()
                                        .getSignInScreenSwitchRegisterText1(
                                            getLanguageCode),
                                textScaler: const TextScaler.linear(1.0),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale((screenHeight *
                                            (12 / AppConfig().screenHeight))),
                                    color: darkMode
                                        ? AppConfig()
                                            .signInScreenSwitchTextDarkColor1
                                        : AppConfig()
                                            .signInScreenSwitchTextLightColor1,
                                    fontFamily: AppConfig().outfitFontRegular),
                              ),
                              // child: languageFutureWidget(
                              //     screenWidth: screenWidth,
                              //     screenHeight: screenHeight,
                              //     selectedLanguage: getLanguageCode,
                              //     getLanguageTranslatorMethod:
                              //         switchLogIn1TextFutureMethod,
                              //     getFontSize:
                              //         AppConfig().signInScreenSwitchTextSize,
                              //     getDarkMode: darkMode,
                              //     getTextAlign: TextAlign.center,
                              //     getTextColor: darkMode
                              //         ? AppConfig()
                              //             .signInScreenSwitchTextDarkColor1
                              //         : AppConfig()
                              //             .signInScreenSwitchTextLightColor1,
                              //     getFontFamily: AppConfig().outfitFontRegular,
                              //     getTextDirection: LanguageTextFile()
                              //         .getTextDirection(getLanguageCode),
                              //     getSoftWrap: true),
                            ),
                            Container(
                              // child: languageFutureWidget(
                              //     screenWidth: screenWidth,
                              //     screenHeight: screenHeight,
                              //     selectedLanguage: getLanguageCode,
                              //     getLanguageTranslatorMethod:
                              //         switchLogIn2TextFutureMethod,
                              //     getFontSize:
                              //         AppConfig().signInScreenSwitchTextSize,
                              //     getDarkMode: darkMode,
                              //     getTextAlign: TextAlign.center,
                              //     getTextColor: darkMode
                              //         ? AppConfig()
                              //             .signInScreenSwitchTextDarkColor2
                              //         : AppConfig()
                              //             .signInScreenSwitchTextLightColor2,
                              //     getFontFamily: AppConfig().outfitFontRegular,
                              //     getTextDirection: LanguageTextFile()
                              //         .getTextDirection(getLanguageCode),
                              //     getSoftWrap: true),
                              child: Text(
                                logInScreen
                                    ? LanguageTextFile()
                                        .getSignInScreenSwitchLogInText2(
                                            getLanguageCode)
                                    : LanguageTextFile()
                                        .getSignInScreenSwitchRegisterText2(
                                            getLanguageCode),
                                textScaler: const TextScaler.linear(1.0),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale((screenHeight *
                                            (12 / AppConfig().screenHeight))),
                                    color: darkMode
                                        ? AppConfig()
                                            .signInScreenSwitchTextDarkColor2
                                        : AppConfig()
                                            .signInScreenSwitchTextLightColor2,
                                    fontFamily: AppConfig().outfitFontRegular),
                              ),
                            )
                          ],
                        ),
                        /*child: RichText(
                              textScaler: TextScaler.linear(1),
                              textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
                              text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text:logInScreen?LanguageTextFile().getSignInScreenSwitchLogInText1():LanguageTextFile().getSignInScreenSwitchRegisterText1(),style: TextStyle(fontSize: screenHeight*(AppConfig().signInScreenSwitchTextSize/AppConfig().screenHeight),color: darkMode?AppConfig().signInScreenSwitchTextDarkColor1:AppConfig().signInScreenSwitchTextLightColor1,fontFamily: AppConfig().outfitFontRegular),),
                                    TextSpan(text:logInScreen?LanguageTextFile().getSignInScreenSwitchLogInText2():LanguageTextFile().getSignInScreenSwitchRegisterText2(),style: TextStyle(fontSize: screenHeight*(AppConfig().signInScreenSwitchTextSize/AppConfig().screenHeight),color: darkMode?AppConfig().signInScreenSwitchTextDarkColor2:AppConfig().signInScreenSwitchTextLightColor2,fontFamily: AppConfig().outfitFontRegular),),
                                  ]
                              ),
                            ),*/
                      ),
                    ),
                    SizedBox(
                      height: (screenHeight * (200 / AppConfig().screenHeight)),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: (screenHeight *
                                  (20 / AppConfig().screenHeight))),
                          child: Text(
                            //LanguageTextFile().getDashboardScreenBottomContentText(),
                            LanguageTextFile()
                                .getSignInScreenCopyRightText(getLanguageCode),
                            textScaler: const TextScaler.linear(1.0),
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context)
                                    .textScaler
                                    .scale((screenHeight *
                                        (12 / AppConfig().screenHeight))),
                                color: darkMode
                                    ? AppConfig()
                                        .dashboardScreenBottomCopyRightTextDarkColor
                                    : AppConfig()
                                        .dashboardScreenBottomCopyRightTextLightColor,
                                fontFamily: AppConfig().outfitFontRegular),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            statusBarVisible
                ? Container(
                    width: screenWidth,
                    height: statusBarHeight,
                    color: darkMode
                        ? AppConfig()
                            .signInScreenGradiantStartBackgroundDarkColor
                        : Colors.white,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future googleClick() async {
    final user = await GoogleAuth.login();

    if (user == null) {
      ToastMessage(screenHeight, "No user found", false);
    } else {
      String userDetails = "${user.displayName!} ${user.email}";

      ToastMessage(screenHeight, userDetails, true);
    }
  }
}
