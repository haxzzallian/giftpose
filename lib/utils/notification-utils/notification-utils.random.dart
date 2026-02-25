import 'package:flutter/material.dart';
import 'package:giftpose_app/theme/colors.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationUtil {
  static toast(String msg, {bool isError = false}) {
    showSimpleNotification(Text(msg),
        background: isError ? Colors.red : AppColor.bodyTextColor);
  }
}
