import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GenericTextFormField extends StatefulWidget {
  const GenericTextFormField(
      {Key? key,
      required String this.text,
      required Color this.color,
      required int this.width,
      int? this.height})
      : super(key: key);
  final String text;
  final Color color;
  final int width;
  final int? height;
  @override
  State<GenericTextFormField> createState() => _GenericTextFormFieldState();
}

class _GenericTextFormFieldState extends State<GenericTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }
}
