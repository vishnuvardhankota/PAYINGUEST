import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../GuestScreens/home.dart';

class ManagerScreen extends StatelessWidget {
  const ManagerScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager'),
      ),
      body: Center(
        child: GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                  (route) => false);
            },
            child: const Text('Manager')),
      ),
    );
  }
}