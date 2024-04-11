import 'package:bible_gpt/signInScreen/profile_page.dart';
import 'package:bible_gpt/signInScreen/signinScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/app_config.dart';
import '../config/language_text_file.dart';

Widget MenuBarProfileWidget(
    {required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required bool darkMode,
    required String profilePictureUrl,
    required String getLanguageCode,
    required String profileName,
    required Function(bool) profileClick}) {
  return Container(
    width: screenWidth * (346 / AppConfig().screenWidth),
    height: screenHeight * (83 / AppConfig().screenHeight),
    padding: EdgeInsets.symmetric(
        horizontal: screenWidth * (16 / AppConfig().screenWidth)),
    child: TextButton(
      onPressed: () {
        print("Profile Click");
        profileClick(true);
        print(darkMode);
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => const SigninScreen()));
      },
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        textDirection: LanguageTextFile().getTextDirection(getLanguageCode),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenHeight *
                (AppConfig().chapterScreenDefaultProfilePictureIconHeight /
                    AppConfig().screenHeight),
            height: screenHeight *
                (AppConfig().chapterScreenDefaultProfilePictureIconHeight /
                    AppConfig().screenHeight),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  screenHeight *
                      (AppConfig()
                              .chapterScreenDefaultProfilePictureIconHeight /
                          AppConfig().screenHeight),
                ),
              ),
            ),
            child: profilePictureUrl == ""
                ? SvgPicture.asset(
                    darkMode
                        ? AppConfig()
                            .chapterScreenDefaultProfilePictureIconLight
                        : AppConfig()
                            .chapterScreenDefaultProfilePictureIconLight,
                    fit: BoxFit.fitHeight,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(screenHeight *
                        (AppConfig()
                                .chapterScreenDefaultProfilePictureIconHeight /
                            AppConfig().screenHeight))),
                    child: Image.network(
                      profilePictureUrl,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
          ),
          SizedBox(
            width: screenWidth * (12 / AppConfig().screenWidth),
          ),
          Flexible(
            child: Container(
              child: Text(
                profileName,
                textScaler: const TextScaler.linear(1.0),
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaler.scale(
                        (screenHeight * (16 / AppConfig().screenHeight))),
                    color: darkMode
                        ? AppConfig().chapterScreenMenuProfileTextColorDark
                        : AppConfig().chapterScreenMenuProfileTextColorLight,
                    fontFamily: AppConfig().outfitFontRegular),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
