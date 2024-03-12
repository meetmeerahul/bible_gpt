import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../config/app_config.dart';

Widget MenuBarSocialMediaWidget({required double screenWidth,required double screenHeight,required bool darkMode,required Function(int) getSelectedSocialMediaFunction}){
  return Container(
    width: screenWidth*(346/AppConfig().screenWidth),
    height: screenHeight*(83/AppConfig().screenHeight),
    padding: EdgeInsets.symmetric(horizontal: screenWidth*(16/AppConfig().screenWidth)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: TextButton(
            onPressed: (){
              print("Facebook");
              getSelectedSocialMediaFunction(2);
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Container(
              width: screenWidth*(AppConfig().chapterScreenFacebookIconWidth/AppConfig().screenWidth),
              height: screenHeight*(AppConfig().chapterScreenFacebookIconHeight/AppConfig().screenHeight),
              child: SvgPicture.asset(darkMode?AppConfig().chapterScreenFacebookIconDark:AppConfig().chapterScreenFacebookIconLight,fit: BoxFit.scaleDown,),
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: (){
              print("Twitter");
              getSelectedSocialMediaFunction(3);
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Container(
              width: screenWidth*(AppConfig().chapterScreenTwitterIconWidth/AppConfig().screenWidth),
              height: screenHeight*(AppConfig().chapterScreenTwitterIconHeight/AppConfig().screenHeight),
              child: SvgPicture.asset(darkMode?AppConfig().chapterScreenTwitterIconDark:AppConfig().chapterScreenTwitterIconLight,fit: BoxFit.scaleDown,),
            ),
          ),
        ),
        Container(
          child: TextButton(
            onPressed: (){
              print("Instagram");
              getSelectedSocialMediaFunction(4);
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Container(
              width: screenWidth*(AppConfig().chapterScreenInstagramIconWidth/AppConfig().screenWidth),
              height: screenHeight*(AppConfig().chapterScreenInstagramIconHeight/AppConfig().screenHeight),
              child: SvgPicture.asset(darkMode?AppConfig().chapterScreenInstagramIconDark:AppConfig().chapterScreenInstagramIconLight,fit: BoxFit.scaleDown,),
            ),
          ),
        ),
      ],
    ),
  );
}