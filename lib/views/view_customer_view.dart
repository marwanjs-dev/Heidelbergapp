import 'package:flutter/material.dart';
import 'package:suez_app/components/side_bar.dart';
import 'package:suez_app/constants/colors.dart';
import 'package:suez_app/enums/enums.dart';
import 'package:suez_app/services/api_company_services.dart';
import 'package:suez_app/services/models/album_company.dart';
import 'package:suez_app/utilities/extensions.dart';
import 'package:suez_app/views/components/search_customer_card.dart';
import 'package:suez_app/views/components/transaction_card.dart';

class ViewCustomerView extends StatefulWidget {
  const ViewCustomerView({Key? key}) : super(key: key);
  @override
  State<ViewCustomerView> createState() => _ViewCustomerViewState();
}

class _ViewCustomerViewState extends State<ViewCustomerView> {
  late final TextEditingController _customerCodeEditingController;
  late final TextEditingController _customerNameEditingController;
  late final TextEditingController _allCompaniesCreditEditingController;
  late final TextEditingController _firstAmountEditingController;
  late final TextEditingController _secondAmountEditingController;
  late final TextEditingController _firstCompanyEditingController;
  late final TextEditingController _secondCompanyEditingController;
  late final TextEditingController _amountController;
  late final GlobalKey<State> _LoaderDialog;
  late final fromCompanyId;
  final Color _firstCompanyShareType = myPaleBlue;
  final Color _secondCompanyShareType = myPaleBlue;
  Map<String, int> companyMap = {};
  ButtonState? isButtonDisabled;
  Future<AlbumCompany>? future;

  final bool _isAPILoading = true;

  @override
  void initState() {
    _customerCodeEditingController = TextEditingController();
    _customerNameEditingController = TextEditingController();
    _allCompaniesCreditEditingController = TextEditingController();
    _firstAmountEditingController = TextEditingController();
    _secondAmountEditingController = TextEditingController();
    _firstCompanyEditingController = TextEditingController();
    _secondCompanyEditingController = TextEditingController();
    _amountController = TextEditingController();
    _LoaderDialog = GlobalKey<State>();
    isButtonDisabled = ButtonState();
    future = asyncMethodCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: myPaleBlue,
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("Transactions"),
        centerTitle: true,
        backgroundColor: myOrange,
      ),
      body: ListView(
        children: [
          SearchCustomerCard(
            sw: sw,
            sh: sh,
            customerCodeEditingController: _customerCodeEditingController,
            isAPILoading: _isAPILoading,
            loaderDialog: _LoaderDialog,
            customerNameEditingController: _customerNameEditingController,
            allCompaniesCreditEditingController:
                _allCompaniesCreditEditingController,
            firstAmountEditingController: _firstAmountEditingController,
            secondAmountEditingController: _secondAmountEditingController,
            firstCompanyEditingController: _firstCompanyEditingController,
            secondCompanyEditingController: _secondCompanyEditingController,
            isButtonDisabled: isButtonDisabled,
          ),
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.done:
                  final List<String> items = [];
                  final data = snapshot.data as AlbumCompany;
                  data.data.forEach(
                    (element) {
                      items.add(element['name'].toString());
                      companyMap[element['name'].toString()] =
                          element['companyId'];
                    },
                  );
                  return TransactionCard(
                    sw: sw,
                    amountController: _amountController,
                    isButtonDisabled: isButtonDisabled,
                    items: items,
                    firstAmountEditingController: _firstAmountEditingController,
                    secondAmountEditingController:
                        _secondAmountEditingController,
                    firstCompanyEditingController:
                        _firstCompanyEditingController,
                    secondCompanyEditingController:
                        _secondCompanyEditingController,
                    companyMap: companyMap,
                  );
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<AlbumCompany> asyncMethodCall() async {
  return await fetchAllCompaniesAlbum();
}
