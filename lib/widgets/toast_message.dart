import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../config/app_config.dart';

ToastMessage(
  double screenHeight,
  String getMessage,
  bool toastType,
) {
  return Fluttertoast.showToast(
    msg: getMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 1,
    backgroundColor: toastType ? Colors.green : Colors.red,
    textColor: Colors.white,
    fontSize: screenHeight * (12 / AppConfig().screenHeight),
  );
}
