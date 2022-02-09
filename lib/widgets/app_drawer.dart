import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/screens/GuestScreens/home.dart';
import 'package:payinguest/screens/maintainer_profile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? maintainerId = FirebaseAuth.instance.currentUser?.uid;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close)),
              title: const Text('PAYINGUEST'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MaintainerProfile(maintainerId: maintainerId!,)));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                    (route) => false);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
