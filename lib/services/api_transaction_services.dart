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

Future<bool> postTransaction({
  required int fromCompanyId,
  required int toCompanyId,
  required int amount,
  required String customerId,
}) async {
  HttpOverrides.global = MyHttpOverrides();
  try {
    var map = new Map<String, dynamic>();
    map['fromCompanyId'] = fromCompanyId;
    map['toCompanyId'] = toCompanyId;
    map['amount'] = amount;
    map['customerId'] = customerId;
    print(json.encode(map));

    var response = await http.post(
        Uri.parse('https://10.0.2.2:7201/api/Transaction'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode(map));
    if (response.statusCode == 201) {
      return true;
    } else {
      print(response.body.toString());
      throw CouldNotPostTransactionException();
    }
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}
