import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Guest {
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
  String hostelId;
  String ownerId;
  String managerId;
  int roomNum;
  Guest({
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
    required this.hostelId,
    required this.ownerId,
    required this.managerId,
    required this.roomNum,
  });
}

class GuestProvider with ChangeNotifier {
  List<Guest> guests = [];
  List<Guest> get allGuests {
    return [...guests];
  }

  Guest guestById(String id) {
    return allGuests.firstWhere((guest) => guest.guestId == id);
  }

  List<Guest> guestsByRoomNum(int roomNum) {
    return allGuests.where((guest) => guest.roomNum == roomNum).toList();
  }

  List<Guest> alljoinedguests() {
    return allGuests.where((guest) => guest.roomNum != 0).toList();
  }

  Guest newGuestById(String id) {
    return allGuests.firstWhere((guest) => guest.guestId == id);
  }

  List<Guest> allnewGuests() {
    return allGuests.where((guest) => guest.roomNum == 0).toList();
  }

  Future<void> addGuest(
    BuildContext context,
    Guest newguest,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Guests')
          .doc(newguest.guestId)
          .set({
        'guestId': newguest.guestId,
        'name': newguest.name,
        'profile': newguest.profile,
        'gender': newguest.gender,
        'age': newguest.age,
        'guestDOB': newguest.guestDOB,
        'phoneNum': newguest.phoneNum,
        'parentPhoneNum': newguest.parentPhoneNum,
        'email': newguest.email,
        'address': newguest.address,
        'aadharFront': newguest.aadharFront,
        'aadharBack': newguest.aadharBack,
        'idCard': newguest.idCard,
        'workingPlace': newguest.workingPlace,
        'graduation': newguest.graduation,
        'stayingBase': newguest.stayingBase,
        'rent': newguest.rent,
        'guestDOJ': newguest.guestDOJ,
        'hostelId': newguest.hostelId,
        'ownerId': newguest.ownerId,
        'managerId': newguest.managerId,
        'roomNum': newguest.roomNum,
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

  Future<void> myGuests(
    BuildContext context,
    String hostelId,
  ) async {
    try {
      final List<Guest> searchedGuests = [];
      await FirebaseFirestore.instance
          .collection('Guests')
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((data) {
                return searchedGuests.add(Guest(
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
                    hostelId: data['hostelId'],
                    ownerId: data['ownerId'],
                    managerId: data['managerId'],
                    roomNum: data['roomNum']));
              }));
      guests = searchedGuests;
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

  Future<void> addGuestToRoom(BuildContext context, int roomNum,
      String hostelId, String guestId, int rent) async {
    try {
      FirebaseFirestore.instance
          .collection('Guests')
          .doc(guestId)
          .update({'roomNum': roomNum, 'rent': rent});
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

  Future<void> changeRoom(BuildContext context, int roomNum, String hostelId,
      String guestId) async {
    try {
      FirebaseFirestore.instance
          .collection('Guests')
          .doc(guestId)
          .update({
        'roomNum': roomNum,
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
}
