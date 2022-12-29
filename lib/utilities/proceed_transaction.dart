import 'package:flutter/material.dart';
import 'package:suez_app/utilities/generic_dialog.dart';

Future<bool> showTransactionDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: "Transaction",
    content: "Are you sure you want to proceed?",
    optionsBuilder: () => {
      "cancel": false,
      "proceed": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
