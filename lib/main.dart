import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/provider/maintainer.dart';
import 'package:payinguest/provider/paid_receipt.dart';
import 'package:payinguest/provider/vacatedguest.dart';
import 'package:payinguest/screens/GuestScreens/home.dart';
import 'package:payinguest/screens/Owner/owner_screen.dart';
import 'package:provider/provider.dart';
import 'provider/room.dart';
import 'screens/manager/manager_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MaintainerProvider()),
    ChangeNotifierProvider(create: (context) => GuestProvider()),
    ChangeNotifierProvider(create: (context) => HostelProvider()),
    ChangeNotifierProvider(create: (context) => RoomSharingProvider()),
    ChangeNotifierProvider(create: (context) => VacatedGuestProvider()),
    ChangeNotifierProvider(create: (context) => PaidReceiptProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentUser = FirebaseAuth.instance.currentUser?.uid;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Maintainers')
                  .doc(currentUser)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data?['role'] == 'Manager') {
                  return const ManagerScreen();
                }

                return const OwnerScreen();
              },
            );
          }
          return const MyHomePage();
        },
      ),
    );
  }
}
  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();