import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:payinguest/provider/guest.dart';

class VacatedGuest {
  String guestId;
  String name;
  String profile;
  int gender;
  String age;
  String guestDOB;
  String phoneNum;
  String parentPhoneNum;
  String email;
  String address;
  String aadharFront;
  String aadharBack;
  String? idCard;
  String workingPlace;
  String graduation;
  int stayingBase;
  int rent;
  String guestDOJ;
  String guestDOV;
  String ownerId;
  String managerId;
  int roomNum;
  VacatedGuest({
    required this.guestId,
    required this.name,
    required this.profile,
    required this.gender,
    required this.age,
    required this.guestDOB,
    required this.phoneNum,
    required this.parentPhoneNum,
    required this.email,
    required this.address,
    required this.aadharFront,
    required this.aadharBack,
    required this.idCard,
    required this.workingPlace,
    required this.graduation,
    required this.stayingBase,
    required this.rent,
    required this.guestDOJ,
    required this.guestDOV,
    required this.ownerId,
    required this.managerId,
    required this.roomNum,
  });
}

class VacatedGuestProvider with ChangeNotifier {
  List<VacatedGuest> vacatedGuest = [];
  List<VacatedGuest> get allVacatedGuests {
    return [...vacatedGuest];
  }

  VacatedGuest vacatedGuestById(String id) {
    return vacatedGuest.firstWhere((guest) => guest.guestId == id);
  }

  List<VacatedGuest> vacatedGuests() {
    return vacatedGuest.where((guest) => guest.roomNum != 0).toList();
  }

  Future<void> vacateGuest(
      BuildContext context, Guest vacatedGuest, String hostelId) async {
    final vacatedTime = DateFormat().add_yMMMd().format(DateTime.now());
    try {
      await FirebaseFirestore.instance
          .collection('VacatedGuests')
          .doc(vacatedGuest.guestId)
          .set({
        'guestId': vacatedGuest.guestId,
        'name': vacatedGuest.name,
        'profile': vacatedGuest.profile,
        'gender': vacatedGuest.gender,
        'age': vacatedGuest.age,
        'guestDOB': vacatedGuest.guestDOB,
        'phoneNum': vacatedGuest.phoneNum,
        'parentPhoneNum': vacatedGuest.parentPhoneNum,
        'email': vacatedGuest.email,
        'address': vacatedGuest.address,
        'aadharFront': vacatedGuest.aadharFront,
        'aadharBack': vacatedGuest.aadharBack,
        'idCard': vacatedGuest.idCard,
        'workingPlace': vacatedGuest.workingPlace,
        'graduation': vacatedGuest.graduation,
        'stayingBase': vacatedGuest.stayingBase,
        'rent': vacatedGuest.rent,
        'guestDOJ': vacatedGuest.guestDOJ,
        'guestDOV': vacatedTime,
        'ownerId': vacatedGuest.ownerId,
        'managerId': vacatedGuest.managerId,
        'roomNum': vacatedGuest.roomNum,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Guests')
            .doc(vacatedGuest.guestId)
            .delete();
      });
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(error.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
    notifyListeners();
  }

  Future<void> myVacatedGuests(
    BuildContext context,
    String hostelId,
  ) async {
    try {
      final List<VacatedGuest> searchedVacatedGuests = [];
      await FirebaseFirestore.instance
          .collection('VacatedGuests')
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((data) {
                return searchedVacatedGuests.add(VacatedGuest(
                    guestId: data['guestId'],
                    name: data['name'],
                    profile: data['profile'],
                    gender: data['gender'],
                    age: data['age'],
                    guestDOB: data['guestDOB'],
                    phoneNum: data['phoneNum'],
                    parentPhoneNum: data['parentPhoneNum'],
                    email: data['email'],
                    address: data['address'],
                    aadharFront: data['aadharFront'],
                    aadharBack: data['aadharBack'],
                    idCard: data['idCard'],
                    workingPlace: data['workingPlace'],
                    graduation: data['graduation'],
                    stayingBase: data['stayingBase'],
                    rent: data['rent'],
                    guestDOJ: data['guestDOJ'],
                    guestDOV: data['guestDOV'],
                    ownerId: data['ownerId'],
                    managerId: data['managerId'],
                    roomNum: data['roomNum']));
              }));
      vacatedGuest = searchedVacatedGuests;
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(error.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
    notifyListeners();
  }
}
