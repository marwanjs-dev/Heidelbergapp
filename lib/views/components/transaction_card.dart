import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:suez_app/constants/colors.dart';
import 'package:suez_app/enums/enums.dart';
import 'package:suez_app/services/api_balance_services.dart';
import 'package:suez_app/services/api_transaction_services.dart';
import 'package:suez_app/services/models/album_balance.dart';
import 'package:suez_app/utilities/extensions.dart';
import 'package:suez_app/utilities/proceed_transaction.dart';
import 'package:suez_app/utilities/show_error_dialog.dart';

class TransactionCard extends StatefulWidget {
  TransactionCard({
    Key? key,
    required this.sw,
    required this.amountController,
    required this.isButtonDisabled,
    required this.items,
    required this.firstAmountEditingController,
    required this.secondAmountEditingController,
    required this.firstCompanyEditingController,
    required this.secondCompanyEditingController,
    required this.companyMap,
  }) : super(key: key);
  final sw;
  final amountController;
  final List<String> items;
  final TextEditingController firstAmountEditingController;
  final TextEditingController secondAmountEditingController;
  final TextEditingController firstCompanyEditingController;
  final TextEditingController secondCompanyEditingController;
  final Map<String, int> companyMap;
  ButtonState? isButtonDisabled;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  String? dropDownValue1;
  String? dropDownValue2;
  late final int fromCompanyId;
  late final int toCompanyId;
  Map<String, int> map = {};

  @override
  Widget build(BuildContext context) {
    return Card(
      color: myDeepBlue,
      child: Column(
        children: [
          // drop down buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // drop down button 1
              DropdownButton(
                hint: const Text(
                  "company name",
                  style: TextStyle(
                    color: myWhite,
                  ),
                ),
                dropdownColor: myOrange,
                style: const TextStyle(color: myWhite),
                value: dropDownValue1,
                onChanged: (String? newValue1) {
                  setState(() {
                    dropDownValue1 = newValue1!;
                  });
                },
                items: widget.items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
              ),
              SizedBox(
                width: widget.sw * 0.1,
              ),
              // drop down button 2
              DropdownButton(
                hint: const Text(
                  "company name",
                  style: TextStyle(
                    color: myWhite,
                  ),
                ),
                dropdownColor: myOrange,
                style: const TextStyle(color: myWhite),
                value: dropDownValue2,
                onChanged: (String? newValue2) {
                  setState(() {
                    dropDownValue2 = newValue2!;
                  });
                },
                items: widget.items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
              ),
            ],
          ),
          // amount input
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Amount",
                style: TextStyle(
                  color: myWhite,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 200,
                child: Card(
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Can\'t be empty';
                      } else if (double.tryParse(text) != null) {
                        return 'please input a number';
                      }
                      return null;
                    },
                    controller: widget.amountController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: "start typing your amount",
                    ),
                  ),
                ),
              ),
            ],
          ),
          //comments
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "comments",
                  style: TextStyle(
                    color: myWhite,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Card(
                    child: TextFormField(
                      controller: widget.amountController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "start typing your amount",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () async {
                setState(() {});
                if (widget.isButtonDisabled?.state == true) {
                  showErrorDialog(context, "error");
                } else if (dropDownValue1 == dropDownValue2) {
                  showErrorDialog(
                    context,
                    "please choose a different company",
                  );
                } else if (widget.amountController.text.isEmpty) {
                  showErrorDialog(
                    context,
                    "please enter an amount",
                  );
                } else {
                  if (dropDownValue1 != null && dropDownValue2 != null) {
                    final int fromAmount = int.parse(widget
                        .firstAmountEditingController.text
                        .replaceAll(",", ''));
                    final int toAmount = int.parse(widget
                        .secondAmountEditingController.text
                        .replaceAll(",", ''));
                    print(fromAmount);
                    if (('${dropDownValue1!} Cement').toLowerCase() ==
                        widget.firstCompanyEditingController.text
                            .toLowerCase()) {
                      map['${dropDownValue1!} Cement'] = fromAmount;
                      map['${dropDownValue2!} Cement'] = toAmount;
                    } else {
                      map['${dropDownValue2!} Cement'] = fromAmount;
                      map['${dropDownValue1!} Cement'] = toAmount;
                    }
                  }
                  if (map['${dropDownValue1!} Cement']! <
                      int.parse(widget.amountController.text)) {
                    showErrorDialog(context, "invalid amount");
                  } else {
                    final proceedTransaction =
                        await showTransactionDialog(context);
                    if (proceedTransaction &&
                        widget.companyMap.isNotEmpty &&
                        isNumeric(widget.amountController.text)) {
                      int amount = int.parse(widget.amountController.text);
                      int fromCompanyId = widget.companyMap[dropDownValue1]!;
                      int toCompanyId = widget.companyMap[dropDownValue2]!;
                      int newFirstCompanyAmount = int.parse(widget
                              .firstAmountEditingController.text
                              .replaceAll(",", "")) -
                          int.parse(widget.amountController);
                      int newSecondCompanyAmount = int.parse(widget
                              .secondAmountEditingController.text
                              .replaceAll(",", "")) +
                          -int.parse(widget.amountController);
                      String customerId =
                          '19706aee-11ca-468e-b44ade-d20dfcd9239d';
                      Map<String, dynamic> balanceMap = {};
                      AlbumBalance z =
                          await fetchBalancesByCustomer(customerId: customerId);
                      z.data.forEach((element) {
                        if (element['companyId'] == fromCompanyId) {
                          balanceMap[fromCompanyId.toString()] =
                              newFirstCompanyAmount;
                        } else {
                          balanceMap[toCompanyId.toString()] =
                              newSecondCompanyAmount;
                        }
                        balanceMap[fromCompanyId.toString()] = {};
                      });
                      //final bool y = updateBalance(companyId: fromCompanyId, amount: amount, customerId: customerId)
                      final bool x = await postTransaction(
                        fromCompanyId: fromCompanyId,
                        toCompanyId: toCompanyId,
                        amount: amount,
                        customerId: customerId,
                      );
                    }
                  }
                }
              },
              child: Text(widget.isButtonDisabled?.state == true
                  ? "Hold on..."
                  : "Transfer"))
        ],
      ),
    );
  }
}
