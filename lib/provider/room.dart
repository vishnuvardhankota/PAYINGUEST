import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomSharing {
  String roomId;
  int roomNum;
  int typeSharing;
  String hostelId;
  String ownerId;
  String managerId;
  RoomSharing(
      {required this.roomId,
      required this.roomNum,
      required this.typeSharing,
      required this.hostelId,
      required this.ownerId,
      required this.managerId});
}

class RoomSharingProvider with ChangeNotifier {
  List<RoomSharing> rooms = [];
  List<RoomSharing> get allRooms {
    return [...rooms];
  }

  RoomSharing roomById(String id) {
    return rooms.firstWhere((room) => room.roomId == id);
  }

  Future<void> addRoom(
      BuildContext context, RoomSharing room, String hostelId) async {
    try {
      await FirebaseFirestore.instance
          .collection('HostelRooms')
          .doc(room.roomId)
          .set({
        'roomId': room.roomId,
        'roomNum': room.roomNum,
        'typeSharing': room.typeSharing,
        'hostelId': room.hostelId,
        'ownerId': room.ownerId,
        'managerId': room.managerId,
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

  Future<void> updateRoom(
      BuildContext context, RoomSharing room, String hostelId) async {
    try {
      await FirebaseFirestore.instance
          .collection('HostelRooms')
          .doc(room.roomId)
          .update({
        'roomNum': room.roomNum,
        'typeSharing': room.typeSharing,
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

  Future<void> deleteRoom(
      BuildContext context, RoomSharing room, String hostelId) async {
    try {
      FirebaseFirestore.instance
          .collection('HostelRooms')
          .doc(room.roomId)
          .delete();
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

  Future<void> getRooms(BuildContext context, String? hostelId) async {
    try {
      final List<RoomSharing> roomList = [];
      await FirebaseFirestore.instance
          .collection('HostelRooms')
          .orderBy('roomNum', descending: false)
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((prdt) async {
                return roomList.add(RoomSharing(
                  roomId: prdt['roomId'],
                  roomNum: prdt['roomNum'],
                  typeSharing: prdt['typeSharing'],
                  hostelId: prdt['hostelId'],
                  ownerId: prdt['ownerId'],
                  managerId: prdt['managerId'],
                ));
              }));
      rooms = roomList;
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

  int get totalStrength {
    var total = 0;
    for (var element in rooms) {
      total += element.typeSharing;
    }
    return total;
  }
}
