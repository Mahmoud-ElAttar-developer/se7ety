import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// دالة عرض الخطأ باستخدام SnackBar
void showErrorDialog(BuildContext context, String errorText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(10),
      content: Text(errorText),
    ),
  );
}

// دالة عرض مؤشر التحميل باستخدام أنيميشن Lottie
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha((0.7 * 255).round()),
    builder: (BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/Sandy Loading.json',
            width: 150,
            height: 150,
          ),
        ],
      );
    },
  );
}
