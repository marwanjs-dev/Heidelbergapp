import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:suez_app/services/api_company_services.dart';
import 'package:suez_app/services/api_services.dart';
import 'package:suez_app/services/models/album_company.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                final result = await fetchAllCompaniesAlbum();
                final data = result.data;
                data.forEach(
                  (element) {
                    print(element['companyId']);
                  },
                );
              },
              child: const Text("child"))
        ],
      ),
    );
  }
}
