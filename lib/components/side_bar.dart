import 'package:flutter/material.dart';
import 'package:suez_app/constants/routes.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('View Customer'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(viewCustomerRoute, (route) => false)
            },
          ),
        ],
      ),
    );
  }
}
