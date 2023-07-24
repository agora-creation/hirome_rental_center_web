import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kCompanyName = 'ひろめ市場';
const kSystemName = '食器レンタルシステム';
const kForName = '食器センター専用';

const kDefaultImageUrl = 'assets/images/default.png';

const kBaseColor = Color(0xFF009688);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kGrey2Color = Color(0xFF757575);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);
const kLightBlueColor = Color(0xFF03A9F4);
const kGreenColor = Color(0xFF4CAF50);
const kOrangeColor = Color(0xFFFF9800);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kBaseColor,
    fontFamily: 'SourceHanSansJP-Regular',
    appBarTheme: const AppBarTheme(
      color: kBaseColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        color: kWhiteColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      iconTheme: IconThemeData(color: kWhiteColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kBlackColor),
      bodyMedium: TextStyle(color: kBlackColor),
      bodySmall: TextStyle(color: kBlackColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kWhiteColor,
      elevation: 5,
      selectedItemColor: kBlueColor,
      unselectedItemColor: kGrey2Color,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kBlueColor,
      elevation: 5,
      extendedTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kGreyColor,
  );
}

const SliverGridDelegate kProductGrid =
    SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 6,
  childAspectRatio: 1,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
);

DateTime kSearchFirstDate = DateTime(2023, 1, 1);
DateTime kSearchLastDate = DateTime(2100, 12, 31);
