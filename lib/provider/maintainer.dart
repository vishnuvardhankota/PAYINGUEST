import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Maintainer {
  String maintainerId;
  String name;
  String phoneNumber;
  String email;
  String role;

  Maintainer({
    required this.maintainerId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.role,
  });
}

class MaintainerProvider with ChangeNotifier {
  List<Maintainer> maintainers = [];
  List<Maintainer> get allmaintainers {
    return [...maintainers];
  }

  Maintainer findById(String maintainerId) {
    return maintainers
        .firstWhere((maintainer) => maintainer.maintainerId == maintainerId);
  }

  Future<void> createAccount(
      BuildContext context, Maintainer maintainer, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: maintainer.email, password: password)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('Maintainers')
            .doc(value.user?.uid)
            .set({
          'maintainerId': value.user?.uid,
          'name': maintainer.name,
          'phoneNumber': maintainer.phoneNumber,
          'email': maintainer.email,
          'role': maintainer.role
        });
        value.user?.sendEmailVerification();
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
  }

  Future<void> updatePhoneNumber(
      BuildContext context, String maintainerId, String phoneNumber) async {
    try {
      FirebaseFirestore.instance
          .collection('Maintainers')
          .doc(maintainerId)
          .update({'phoneNumber': phoneNumber});
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
  }

  Future<void> maintainerData(
      BuildContext context, String currentUserId) async {
    try {
      FirebaseFirestore.instance
          .collection('Maintainers')
          .doc(currentUserId)
          .get()
          .then((DocumentSnapshot snapshot) {
        return maintainers.add(Maintainer(
            maintainerId: snapshot.get('maintainerId'),
            name: snapshot.get('name'),
            phoneNumber: snapshot.get('phoneNumber'),
            email: snapshot.get('email'),
            role: snapshot.get('role')));
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
  }
}
