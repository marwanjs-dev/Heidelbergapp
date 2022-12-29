import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:suez_app/services/models/album.dart';
import 'package:suez_app/services/exceptions.dart';
import 'package:suez_app/services/models/album_company.dart';
import 'package:suez_app/utilities/show_error_dialog.dart';
import 'package:dio/dio.dart';

import '../main.dart';
import 'models/album_balance.dart';

Future<bool> updateBalance({
  required int companyId,
  required int amount,
  required String customerId,
}) async {
  HttpOverrides.global = MyHttpOverrides();
  try {
    var map = new Map<String, dynamic>();
    map['companyId'] = companyId;
    map['amount'] = amount;
    map['customerId'] = customerId;
    print(json.encode(map));

    var response = await http.put(
        Uri.parse('https://10.0.2.2:7201/api/Balance'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode(map));
    if (response.statusCode == 201) {
      return true;
    } else {
      throw CouldNotPostTransactionException();
    }
  } catch (e) {
    rethrow;
  }
}

Future<AlbumBalance> fetchBalancesByCustomer(
    {required String customerId}) async {
  HttpOverrides.global = MyHttpOverrides();
  try {
    var response = await http.get(Uri.parse(
        'https://localhost:7201/api/Balance/GetBalanceById?customerId=$customerId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = {};
      map['data'] = jsonDecode(response.body);
      return AlbumBalance.fromJson(map);
    } else {
      throw CouldNotFindCompaniesException();
    }
  } catch (e) {
    rethrow;
  }
}
