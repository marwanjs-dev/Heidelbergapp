import 'package:flutter/material.dart';

extension MoneyFormatter on String {
  String formattedMoney() {
    if (this.length == 0) {
      return '0';
    }
    String newBalance = "";
    for (var i = 0; i < this.length; i++) {
      if (i % 3 == 0 && i != 0) {
        newBalance += ",";
      }
      newBalance += this[i];
    }
    return newBalance.reversed();
  }
}

extension StringManipulator on String {
  String reversed() {
    String temp = "";

    for (int i = this.length - 1; i >= 0; i--) {
      temp += this[i];
    }

    return temp;
  }
}

class ButtonState {
  ButtonState({
    this.state = true,
  });

  bool state;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
