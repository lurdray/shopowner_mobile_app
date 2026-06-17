import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

void shopOwnerLog(
  dynamic msg, {
  StackTrace? stackTrace,
  String logType = '',
}) {
  log(
    '${logType.toUpperCase()}==> $msg',
    stackTrace: stackTrace,
  );
}

void shopOwnerLogger(
  dynamic msg, {
  String logType = '',
  bool isError = false,
  StackTrace? stackTrace,
}) {
  if (!isError) {
    logger.i('${logType.toUpperCase()} : ${msg.toString()}');
  } else {
    logger.e(
      '${logType.toUpperCase()} : ${msg.toString()}',
      stackTrace: stackTrace,
    );
  }
}

Future<void> delayedFunc(
  Function() func, [
  Duration duration = const Duration(seconds: 1),
]) async {
  await Future.delayed(duration, func);
}

void removeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void showScaffoldSnackBar(
  BuildContext context, {
  required String text,
  Color? bgColor,
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: bgColor,
      duration: duration,
    ),
  );
}

String formatDate(DateTime dateTime) {
  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String day = DateFormat("d").format(dateTime);
  String dayWithSuffix = day + getDaySuffix(int.parse(day));
  return "$dayWithSuffix of ${DateFormat("MMMM").format(dateTime)}, ${DateFormat("yyyy").format(dateTime)}";
}

String formatShortDate(DateTime dateTime) {
  return DateFormat("dd MMM, yyyy").format(dateTime);
}

String formatCurrency(num amount, {String symbol = '₦'}) {
  final formatter = NumberFormat.currency(
    locale: 'en_NG',
    symbol: symbol,
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

List<Shadow> get fontShadow {
  return [
    Shadow(
      offset: const Offset(3.0, 3.0),
      blurRadius: 5.0,
      color: Colors.black.withOpacity(.5),
    ),
  ];
}

void showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  String confirmText = 'OK',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool changeR = false,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            if (changeR) Navigator.of(ctx).pop();
            onConfirm?.call();
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
