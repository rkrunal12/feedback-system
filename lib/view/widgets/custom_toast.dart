import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../color.dart';

class CustomeToast {
  static void showSuccess(String message) {
    final notification = Toastification().show(
      title: Text(message),
      icon: const Icon(Icons.notifications_active),
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.flatColored,
      primaryColor: ColorClass.primaryColor,
      alignment: Alignment.topRight,
    );
    toastification.dismiss(notification);
  }

  static void showError(String message) {
    final notification = Toastification().show(
      title: Text(message),
      icon: const Icon(Icons.error),
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.flatColored,
      primaryColor: ColorClass.red,
      alignment: Alignment.topRight,
    );
    toastification.dismiss(notification);
  }
}
