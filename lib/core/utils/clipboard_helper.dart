import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Clipboard utility with user feedback.
class ClipboardHelper {
  ClipboardHelper._();

  static Future<void> copy(String text, {String? message}) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      message ?? 'Copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
