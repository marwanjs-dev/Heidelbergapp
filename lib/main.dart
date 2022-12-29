import 'dart:io';

import 'package:flutter/material.dart';
import 'package:suez_app/constants/routes.dart';
import 'package:suez_app/services/models/album.dart';
import 'package:suez_app/views/test_env.dart';
import 'package:suez_app/views/view_customer_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ViewCustomerView(),
      routes: {
        viewCustomerRoute: (context) => const ViewCustomerView(),
      }));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
