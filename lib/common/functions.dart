import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void pushScreen(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void pushReplacementScreen(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: true,
    ),
  );
}

void showBottomUpScreen(BuildContext context, Widget widget) {
  showMaterialModalBottomSheet(
    expand: true,
    context: context,
    builder: (context) => widget,
  );
}

Future<int?> getPrefsInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future setPrefsInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

Future<double?> getPrefsDouble(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(key);
}

Future setPrefsDouble(String key, double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, value);
}

Future<String?> getPrefsString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future setPrefsString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<bool?> getPrefsBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

Future setPrefsBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future<List<String>?> getPrefsList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}

Future setPrefsList(String key, List<String> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}

Future removePrefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

Future allRemovePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

String dateText(String format, DateTime? date) {
  String ret = '';
  if (date != null) {
    ret = DateFormat(format, 'ja').format(date);
  }
  return ret;
}

String rndText(int length) {
  const tmp = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  int tmpLength = tmp.length;
  final rnd = Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rnd.nextInt(tmpLength);
      return tmp.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}

void showMessage(BuildContext context, String message, bool success) {
  showTopSnackBar(
    Overlay.of(context),
    success
        ? CustomSnackBar.success(message: message)
        : CustomSnackBar.error(message: message),
    snackBarPosition: SnackBarPosition.bottom,
  );
}

Future<List<DateTime?>?> showDataRangePickerDialog(
  BuildContext context,
  DateTime? startValue,
  DateTime? endValue,
) async {
  List<DateTime?>? results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
    ),
    dialogSize: const Size(325, 400),
    value: [startValue, endValue],
    borderRadius: BorderRadius.circular(8),
    dialogBackgroundColor: kWhiteColor,
  );
  return results;
}

Timestamp convertTimestamp(DateTime date, bool end) {
  String dateTime = '${dateText('yyyy-MM-dd', date)} 00:00:00.000';
  if (end == true) {
    dateTime = '${dateText('yyyy-MM-dd', date)} 23:59:59.999';
  }
  return Timestamp.fromMillisecondsSinceEpoch(
    DateTime.parse(dateTime).millisecondsSinceEpoch,
  );
}

Future fcmSoundPlay() async {
  final assetsAudioPlayer = AssetsAudioPlayer();
  await assetsAudioPlayer.open(Audio(kDefaultSoundUrl));
  double orderVolume = await getPrefsDouble('orderVolume') ?? 0.5;
  assetsAudioPlayer.setVolume(orderVolume);
  await assetsAudioPlayer.play();
}
