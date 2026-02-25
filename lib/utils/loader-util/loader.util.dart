import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:giftpose_app/theme/colors.dart';

class AppLoaderUtil {
  static showSecondaryLoading(String msg) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.threeBounce
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 20.0
      ..progressColor = Colors.white
      ..backgroundColor = appPrimaryColor
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..userInteractions = false
      ..dismissOnTap = false;

    EasyLoading.show(status: msg, maskType: EasyLoadingMaskType.none);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }

  static showCircularLoader(String msg) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.white
      ..indicatorColor = appPrimaryColor
      ..textColor = appPrimaryColor
      ..userInteractions = false
      ..dismissOnTap = false;

    EasyLoading.show(status: msg, maskType: EasyLoadingMaskType.none);
  }
}
