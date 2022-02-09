import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Hostel {
  String hostelId;
  String hostelOwnerId;
  String hostelManagerId;
  String hostelOwnerEmail;
  String hostelImage;
  String hostelName;
  int livingType;
  String hostelOwnerName;
  String hostelManagerName;
  String hostelOwnerNumber;
  String hostelPostalCode;
  String hostelStreet;
  String hostelMainArea;
  String hostelCity;
  String hostelState;
  String dailyBasis;
  String monthlyBasis;
  bool isAdvanceRequired;
  int advanceAmount;
  int returnAmount;
  List hostelImages;
  List facilities;
  bool isPremium;
  String expiryDate;

  Hostel({
    required this.hostelId,
    required this.hostelOwnerId,
    required this.hostelManagerId,
    required this.hostelOwnerEmail,
    required this.hostelImage,
    required this.hostelName,
    required this.livingType,
    required this.hostelOwnerName,
    required this.hostelManagerName,
    required this.hostelOwnerNumber,
    required this.hostelPostalCode,
    required this.hostelStreet,
    required this.hostelMainArea,
    required this.hostelCity,
    required this.hostelState,
    required this.dailyBasis,
    required this.monthlyBasis,
    required this.isAdvanceRequired,
    required this.advanceAmount,
    required this.returnAmount,
    required this.hostelImages,
    required this.facilities,
    required this.isPremium,
    required this.expiryDate,
  });
}

class HostelProvider with ChangeNotifier {
  List<Hostel> hostels = [];
  List<Hostel> get allHostels {
    return [...hostels];
  }

  Hostel findById(String id) {
    return hostels.firstWhere((host) => host.hostelId == id);
  }

  List<Hostel> byCityName(String cityName) {
    return hostels.where((hostel) => hostel.hostelCity == cityName).toList();
  }

  List<Hostel> byPostalCode(String postalCode) {
    return hostels
        .where((hostel) => hostel.hostelPostalCode == postalCode)
        .toList();
  }

  Future<void> ownerHostels(BuildContext context, String ownerId) async {
    try {
      final List<Hostel> searchedHostels = [];
      await FirebaseFirestore.instance
          .collection('Hostels')
          .where('hostelOwnerId', isEqualTo: ownerId)
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((data) {
                return searchedHostels.add(Hostel(
                    hostelId: data['hostelId'],
                    hostelOwnerId: data['hostelOwnerId'],
                    hostelManagerId: data['hostelManagerId'],
                    hostelOwnerEmail: data['hostelOwnerEmail'],
                    hostelImage: data['hostelImage'],
                    hostelName: data['hostelName'],
                    livingType: data['livingType'],
                    hostelOwnerName: data['hostelOwnerName'],
                    hostelManagerName: data['hostelManagerName'],
                    hostelOwnerNumber: data['hostelOwnerNumber'],
                    hostelPostalCode: data['hostelPostalCode'],
                    hostelStreet: data['hostelStreet'],
                    hostelMainArea: data['hostelMainArea'],
                    hostelCity: data['hostelCity'],
                    hostelState: data['hostelState'],
                    dailyBasis: data['dailyBasis'],
                    monthlyBasis: data['monthlyBasis'],
                    isAdvanceRequired: data['isAdvanceRequired'],
                    advanceAmount: data['advanceAmount'],
                    returnAmount: data['returnAmount'],
                    hostelImages: data['hostelImages'],
                    facilities: data['facilities'],
                    isPremium: data['isPremium'],
                    expiryDate: data['expiryDate']));
              }));
      hostels = searchedHostels;
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

  Future<void> managerHostels(BuildContext context, String managerId) async {
    try {
      final List<Hostel> searchedHostels = [];
      await FirebaseFirestore.instance
          .collection('Hostels')
          .where('hostelManagerId', isEqualTo: managerId)
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((data) {
                return searchedHostels.add(Hostel(
                    hostelId: data['hostelId'],
                    hostelOwnerId: data['hostelOwnerId'],
                    hostelManagerId: data['hostelManagerId'],
                    hostelOwnerEmail: data['hostelOwnerEmail'],
                    hostelImage: data['hostelImage'],
                    hostelName: data['hostelName'],
                    livingType: data['livingType'],
                    hostelOwnerName: data['hostelOwnerName'],
                    hostelManagerName: data['hostelManagerName'],
                    hostelOwnerNumber: data['hostelOwnerNumber'],
                    hostelPostalCode: data['hostelPostalCode'],
                    hostelStreet: data['hostelStreet'],
                    hostelMainArea: data['hostelMainArea'],
                    hostelCity: data['hostelCity'],
                    hostelState: data['hostelState'],
                    dailyBasis: data['dailyBasis'],
                    monthlyBasis: data['monthlyBasis'],
                    isAdvanceRequired: data['isAdvanceRequired'],
                    advanceAmount: data['advanceAmount'],
                    returnAmount: data['returnAmount'],
                    hostelImages: data['hostelImages'],
                    facilities: data['facilities'],
                    isPremium: data['isPremium'],
                    expiryDate: data['expiryDate']));
              }));
      hostels = searchedHostels;
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

  Future<void> addHostel(BuildContext context, Hostel newHostel) async {
    try {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(newHostel.hostelId)
          .set({
        'hostelId': newHostel.hostelId,
        'hostelOwnerId': newHostel.hostelOwnerId,
        'hostelManagerId': newHostel.hostelManagerId,
        'hostelOwnerEmail': newHostel.hostelOwnerEmail,
        'hostelImage': newHostel.hostelImage,
        'hostelName': newHostel.hostelName,
        'livingType': newHostel.livingType,
        'hostelOwnerName': newHostel.hostelOwnerName,
        'hostelManagerName': newHostel.hostelManagerName,
        'hostelOwnerNumber': newHostel.hostelOwnerNumber,
        'hostelPostalCode': newHostel.hostelPostalCode,
        'hostelMainArea': newHostel.hostelMainArea,
        'hostelStreet': newHostel.hostelStreet,
        'hostelState': newHostel.hostelState,
        'hostelCity': newHostel.hostelCity,
        'dailyBasis': newHostel.dailyBasis,
        'monthlyBasis': newHostel.monthlyBasis,
        'isAdvanceRequired': newHostel.isAdvanceRequired,
        'advanceAmount': newHostel.advanceAmount,
        'returnAmount': newHostel.returnAmount,
        'hostelImages': newHostel.hostelImages.toList(),
        'facilities': newHostel.facilities.toList(),
        'isPremium': newHostel.isPremium,
        'expiryDate': newHostel.expiryDate,
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

  Future<void> hostelsBySelectedCity(BuildContext context, String city) async {
    try {
      final List<Hostel> searchedHostels = [];
      await FirebaseFirestore.instance
          .collection('Hostels')
          .where('hostelCity', isEqualTo: city)
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((data) {
                return searchedHostels.add(Hostel(
                    hostelId: data['hostelId'],
                    hostelOwnerId: data['hostelOwnerId'],
                    hostelManagerId: data['hostelManagerId'],
                    hostelOwnerEmail: data['hostelOwnerEmail'],
                    hostelImage: data['hostelImage'],
                    hostelName: data['hostelName'],
                    livingType: data['livingType'],
                    hostelOwnerName: data['hostelOwnerName'],
                    hostelManagerName: data['hostelManagerName'],
                    hostelOwnerNumber: data['hostelOwnerNumber'],
                    hostelPostalCode: data['hostelPostalCode'],
                    hostelStreet: data['hostelStreet'],
                    hostelMainArea: data['hostelMainArea'],
                    hostelCity: data['hostelCity'],
                    hostelState: data['hostelState'],
                    dailyBasis: data['dailyBasis'],
                    monthlyBasis: data['monthlyBasis'],
                    isAdvanceRequired: data['isAdvanceRequired'],
                    advanceAmount: data['advanceAmount'],
                    returnAmount: data['returnAmount'],
                    hostelImages: data['hostelImages'],
                    facilities: data['facilities'],
                    isPremium: data['isPremium'],
                    expiryDate: data['expiryDate']));
              }));
      hostels = searchedHostels;
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
