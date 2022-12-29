import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:suez_app/services/models/album.dart';
import 'package:suez_app/services/exceptions.dart';

Future<Album> fetchAlbum({required String id}) async {
  try {
    final response = await http.post(Uri.parse(
        'https://mysuezapi.suezcement.com.eg/api/MySuez/GetCustomerBalance?customerCode=${id}'));
    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw CouldNotFindUserException();
    }
  } catch (e) {
    rethrow;
  }
}
