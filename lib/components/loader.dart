import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderDialog {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            key: key,
            backgroundColor: Colors.white,
            child: Container(
              width: sw * 0.3,
              height: sh * 0.3,
              child: Image.asset(
                'assets/gif/PVtR.gif',
                fit: BoxFit.fill,
              ),
            ));
      },
    );
  }
}
