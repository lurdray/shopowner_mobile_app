import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegExp.hasMatch(this);
  }
}

extension UrlValidation on String {
  bool get isValidUrl {
    const urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(:\d+)?(\/\S*)?$';
    final urlRegExp = RegExp(urlPattern);
    return urlRegExp.hasMatch(this);
  }
}

extension CapitalizeWords on String {
  String capitalizeWords() {
    if (isEmpty) return this;
    List<String> words = split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).toList();
    return capitalizedWords.join(' ');
  }
}

extension DoubleDurationExtension on num {
  Duration get sec => Duration(milliseconds: (this * 1000).round());
  Duration get milliseconds => Duration(milliseconds: (this).round());
  Duration get minutes => Duration(milliseconds: (this * 60000).round());
  Duration get hours => Duration(milliseconds: (this * 3600000).round());
  Duration get days => Duration(milliseconds: (this * 86400000).round());
}

extension SizeExtension on double {
  double get dynH => h;
  double get dynW => w;
}

extension ReverseListExtension<T> on List<T> {
  List<T> reversedList([bool shouldReverse = false]) {
    return shouldReverse ? reversed.toList() : this;
  }
}

extension ConditionalAddAll<T> on List<T> {
  void addAllIf(List<T> items, bool Function(T) condition) {
    for (var item in items) {
      if (condition(item)) add(item);
    }
  }
}

extension NumberFormatter on num {
  String toKFormat() {
    if (this >= 1000 && this < 1000000) {
      return '${(this / 1000).toStringAsFixed(1).replaceAll('.0', '')}k';
    } else if (this >= 1000000 && this < 1000000000) {
      return '${(this / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    } else if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1).replaceAll('.0', '')}B';
    } else {
      return toString();
    }
  }
}

extension MoneyFormat on num {
  String toMoneyFormat([int decimalDigits = 0]) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: decimalDigits,
    );
    return formatter.format(this);
  }
}
