import 'package:giftpose_app/common/data-models/server-rersponse.model.dart';
import 'package:giftpose_app/constant/messages.dart';
import 'package:giftpose_app/utils/loader-util/loader.util.dart';

import 'package:giftpose_app/utils/notification-utils/notification-utils.random.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  Future<bool> performAPIAction({
    required Future<ServerResponse> Function() action,
    bool showSuccessToast = false,
    bool showErrorToast = true,
  }) async {
    try {
      setBusy(true);
      var response = await action();
      setBusy(false);
      if (showSuccessToast && response.msg != null) {
        NotificationUtil.toast(response.msg!);
      }
      return response.status;
    } catch (e) {
      setBusy(false);
      if (showErrorToast) {
        NotificationUtil.toast(e.toString(), isError: true);
      }
      return false;
    }
  }
}
