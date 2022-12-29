import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:suez_app/components/loader.dart';
import 'package:suez_app/constants/colors.dart';
import 'package:suez_app/enums/enums.dart';
import 'package:suez_app/services/api_services.dart';
import 'package:suez_app/services/exceptions.dart';
import 'package:suez_app/utilities/extensions.dart';
import 'package:suez_app/utilities/show_error_dialog.dart';

class SearchCustomerCard extends StatefulWidget {
  final sh;

  final sw;

  final TextEditingController customerCodeEditingController;

  bool isAPILoading;
  GlobalKey<State> loaderDialog;
  ButtonState? isButtonDisabled;

  final customerNameEditingController;
  final allCompaniesCreditEditingController;
  final firstAmountEditingController;
  final secondAmountEditingController;
  final firstCompanyEditingController;
  final secondCompanyEditingController;

  SearchCustomerCard({
    Key? key,
    required this.sw,
    required this.sh,
    required TextEditingController this.customerCodeEditingController,
    required bool this.isAPILoading,
    required GlobalKey<State> this.loaderDialog,
    required TextEditingController this.customerNameEditingController,
    required TextEditingController this.allCompaniesCreditEditingController,
    required TextEditingController this.firstAmountEditingController,
    required TextEditingController this.secondAmountEditingController,
    required TextEditingController this.firstCompanyEditingController,
    required TextEditingController this.secondCompanyEditingController,
    required ButtonState? this.isButtonDisabled,
  }) : super(key: key);

  @override
  State<SearchCustomerCard> createState() => _SearchCustomerCardState();
}

class _SearchCustomerCardState extends State<SearchCustomerCard> {
  Color _firstCompanyShareType = myPaleBlue;
  Color _secondCompanyShareType = myPaleBlue;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: myDeepBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Search Customer",
            style: TextStyle(
              fontSize: 20,
              color: myWhite,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Card(
                    child: TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        if (double.tryParse(text) != null) {
                          return 'please input a number';
                        }
                      },
                      controller: widget.customerCodeEditingController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "start typing your code",
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    // search text button
                    child: TextButton(
                      onPressed: widget.isAPILoading
                          ? () async {
                              if (widget
                                  .customerCodeEditingController.text.isEmpty) {
                                showErrorDialog(
                                  context,
                                  "please enter the customer's code",
                                );
                              } else {
                                try {
                                  LoaderDialog.showLoadingDialog(
                                      context, widget.loaderDialog);
                                  setState(() {
                                    widget.isAPILoading = false;
                                  });

                                  final request = await fetchAlbum(
                                      id: widget
                                          .customerCodeEditingController.text
                                          .toString());
                                  widget.customerNameEditingController.text =
                                      request.customerName;
                                  final firstCompanyShare =
                                      request.balances[0]['balance'].toString();

                                  final secondCompanyShare =
                                      request.balances[1]['balance'].toString();

                                  widget.allCompaniesCreditEditingController
                                      .text = ((firstCompanyShare[0] != '0'
                                              ? int.parse(
                                                  firstCompanyShare.substring(
                                                      1,
                                                      firstCompanyShare
                                                          .indexOf(".")))
                                              : 0) +
                                          ((secondCompanyShare[0] != '0'
                                              ? int.parse(
                                                  secondCompanyShare.substring(
                                                      1,
                                                      secondCompanyShare
                                                          .indexOf(".")))
                                              : 0)))
                                      .toString()
                                      .reversed()
                                      .formattedMoney();

                                  widget.firstAmountEditingController
                                      .text = firstCompanyShare[0] !=
                                          '0'
                                      ? firstCompanyShare
                                          .substring(
                                              1, firstCompanyShare.indexOf("."))
                                          .reversed()
                                          .formattedMoney()
                                      : '0';

                                  widget.secondAmountEditingController.text =
                                      secondCompanyShare[0] != '0'
                                          ? secondCompanyShare
                                              .substring(
                                                  1,
                                                  secondCompanyShare
                                                      .indexOf("."))
                                              .reversed()
                                              .formattedMoney()
                                          : '0';

                                  widget.firstCompanyEditingController.text =
                                      request.balances[0]['companyName']
                                          .toString();

                                  widget.secondCompanyEditingController.text =
                                      request.balances[1]['companyName']
                                          .toString();
                                  setState(() {
                                    widget.isAPILoading = true;
                                    widget.isButtonDisabled?.state = false;

                                    _firstCompanyShareType =
                                        firstCompanyShare[0] == '-'
                                            ? myOrange
                                            : firstCompanyShare[0] == '+'
                                                ? myPaleBlue
                                                : Colors.white;

                                    _secondCompanyShareType =
                                        secondCompanyShare[0] == '-'
                                            ? myOrange
                                            : secondCompanyShare[0] == '+'
                                                ? myPaleBlue
                                                : Colors.white;
                                  });

                                  Navigator.of(
                                          widget.loaderDialog.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                } on CouldNotFindUserException {
                                  showErrorDialog(
                                      context, "the input code is not valid");
                                  Navigator.of(
                                          widget.loaderDialog.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                } catch (e) {
                                  showErrorDialog(context, e.toString());
                                  Navigator.of(
                                          widget.loaderDialog.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                }
                              }
                            }
                          : null,
                      child: const Text("Search"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Customer Name",
            style: TextStyle(
              fontSize: 15,
              color: myWhite,
            ),
          ),
          Card(
            child: SizedBox(
              width: 200,
              child: TextFormField(
                enabled: false,
                readOnly: true,
                controller: widget.customerNameEditingController,
              ),
            ),
          ),
          const Text("Customer All Companies' Credit",
              style: TextStyle(
                fontSize: 15,
                color: myWhite,
              )),
          Card(
            child: SizedBox(
              width: 130,
              child: TextFormField(
                enabled: false,
                readOnly: true,
                controller: widget.allCompaniesCreditEditingController,
              ),
            ),
          ),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: widget.sw * 0.4,
                    height: widget.sh * 0.15,
                    child: Image.network(
                      "https://media.istockphoto.com/photos/mountain-landscape-picture-id517188688?k=20&m=517188688&s=612x612&w=0&h=i38qBm2P-6V4vZVEaMyTaTEaoCMkYhvLCysE7yJQ5Q=",
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: widget.firstCompanyEditingController,
                      style: const TextStyle(color: myWhite),
                      enabled: false,
                      readOnly: true,
                    ),
                  ),
                  const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 15,
                      color: myWhite,
                    ),
                  ),
                  Card(
                    color: _firstCompanyShareType,
                    child: SizedBox(
                      width: 130,
                      child: TextFormField(
                        enabled: false,
                        readOnly: true,
                        controller: widget.firstAmountEditingController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                children: [
                  Container(
                    width: widget.sw * 0.4,
                    height: widget.sh * 0.15,
                    child: Image.network(
                      "https://media.istockphoto.com/photos/mountain-landscape-picture-id517188688?k=20&m=517188688&s=612x612&w=0&h=i38qBm2P-6V4vZVEaMyTaTEaoCMkYhvLCysE7yJQ5Q=",
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: widget.secondCompanyEditingController,
                      style: const TextStyle(color: myWhite),
                      enabled: false,
                      readOnly: true,
                    ),
                  ),
                  const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 15,
                      color: myWhite,
                    ),
                  ),
                  Card(
                    color: _secondCompanyShareType,
                    child: SizedBox(
                      width: 130,
                      child: TextFormField(
                        enabled: false,
                        readOnly: true,
                        controller: widget.secondAmountEditingController,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
