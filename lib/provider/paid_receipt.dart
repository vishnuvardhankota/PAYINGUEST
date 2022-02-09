import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaidReceipt {
  String receiptId;
  String receiptImage;
  String receiverId;
  String receiverRoomNum;
  String receiverName;
  String receiverPhone;
  int paidAmount;
  String paymentOf;
  Timestamp paidOn;
  String hostelId;
  String givenBy;

  PaidReceipt({
    required this.receiptId,
    required this.receiptImage,
    required this.receiverId,
    required this.receiverRoomNum,
    required this.receiverName,
    required this.receiverPhone,
    required this.paidAmount,
    required this.paymentOf,
    required this.paidOn,
    required this.hostelId,
    required this.givenBy,
  });
}

class PaidReceiptProvider with ChangeNotifier {
  List<PaidReceipt> receipts = [];
  List<PaidReceipt> get allReceipts {
    return [...receipts];
  }

  PaidReceipt recieptById(String id) {
    return allReceipts.firstWhere((receipt) => receipt.receiptId == id);
  }

  List<PaidReceipt> allreceipts(String id) {
    return allReceipts.where((receipt) => receipt.receiptId == id).toList();
  }

  List<PaidReceipt> recieptsByGuestId(String guestId) {
    return allReceipts
        .where((receipt) => receipt.receiverId == guestId)
        .toList();
  }

  Future<void> addReciept(BuildContext context, PaidReceipt receipt) async {
    try {
      FirebaseFirestore.instance
          .collection('Receipts')
          .doc(receipt.receiptId)
          .set({
        'receiptId': receipt.receiptId,
        'receiptImage': receipt.receiptImage,
        'receiverId': receipt.receiverId,
        'receiverRoomNum': receipt.receiverRoomNum,
        'receiverName': receipt.receiverName,
        'receiverPhone': receipt.receiverPhone,
        'paidAmount': receipt.paidAmount,
        'paymentOf': receipt.paymentOf,
        'paidOn': receipt.paidOn,
        'hostelId': receipt.hostelId,
        'givenBy': receipt.givenBy,
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

  Future<void> getReceipts(BuildContext context, String hostelId) async {
    try {
      final List<PaidReceipt> paidReceipts = [];
      await FirebaseFirestore.instance
          .collection('Receipts')
          .where('hostelId', isEqualTo: hostelId)
          .orderBy('paidOn',descending: true)
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((data) {
                return paidReceipts.add(PaidReceipt(
                    receiptId: data['receiptId'],
                    receiptImage: data['receiptImage'],
                    receiverId: data['receiverId'],
                    receiverRoomNum: data['receiverRoomNum'],
                    receiverName: data['receiverName'],
                    receiverPhone: data['receiverPhone'],
                    paidAmount: data['paidAmount'],
                    paymentOf: data['paymentOf'],
                    paidOn: data['paidOn'],
                    hostelId: data['hostelId'],
                    givenBy: data['givenBy']));
              }));
      receipts = paidReceipts;
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
