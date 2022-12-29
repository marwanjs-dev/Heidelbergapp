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

Future<AlbumCompany> fetchAllCompaniesAlbum() async {
  HttpOverrides.global = MyHttpOverrides();
  try {
    //https://10.0.2.2:7201/api/Company
    var response =
        await http.get(Uri.parse('https://10.0.2.2:7201/api/Company'));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = {};
      map['data'] = jsonDecode(response.body);
      return AlbumCompany.fromJson(map);
    } else {
      throw CouldNotFindCompaniesException();
    }
  } catch (e) {
    rethrow;
  }
}
