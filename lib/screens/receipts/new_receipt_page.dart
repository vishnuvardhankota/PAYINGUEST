import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/provider/maintainer.dart';
import 'package:payinguest/provider/paid_receipt.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:payinguest/api/pdf_invoice_api.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NewReceipt extends StatefulWidget {
  final String guestId;
  const NewReceipt({Key? key, required this.guestId}) : super(key: key);

  @override
  State<NewReceipt> createState() => _NewReceiptState();
}

class _NewReceiptState extends State<NewReceipt> {
  bool isCompleted = false;
  Widget infoTitle(String infoTitle) {
    return Text(infoTitle,
        overflow: TextOverflow.fade,
        style: const TextStyle(
            color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget infoDetail(BuildContext context, String infoDetail) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(infoDetail,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.right,
          style: const TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  TextEditingController totalDaysController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  static final List<String> paymentTypes = [
    'Monthlywise',
    'Daywise',
  ];

  String? selectedPaymentType;
  String? monthofPayment;
  DateTime? paymentofMonth = DateTime.now();
  late File pdf;
  bool isLoading = false;

  final newReciept = PaidReceipt(
      receiptId: '',
      receiptImage: '',
      receiverId: '',
      receiverRoomNum: '',
      receiverName: '',
      receiverPhone: '',
      paidAmount: 0,
      paymentOf: '',
      paidOn: Timestamp.now(),
      hostelId: '',
      givenBy: '');

  void monthPicker() {
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(10.0), bottomEnd: Radius.circular(10.0))),
      selectedPeriodStartDecoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            bottomStart: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration:
          const BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle),
    );
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: dp.MonthPicker.single(
                selectedDate: paymentofMonth!,
                firstDate: DateTime.now().subtract(const Duration(days: 350)),
                lastDate: DateTime.now().add(const Duration(days: 350)),
                datePickerStyles: styles,
                onChanged: (newValue) {
                  setState(() {
                    paymentofMonth = newValue;
                    monthofPayment = DateFormat().add_yMMM().format(newValue);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          );
        });
  }

  Widget pdfView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SfPdfViewer.file(
        pdf,
      ),
    );
  }

  Widget formView(Guest guest,Hostel hostel,Maintainer sender){
    return Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.78,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoTitle('Hostel Name :-'),
                          infoDetail(context, hostel.hostelName),
                          infoTitle('For Support :-'),
                          infoDetail(context, hostel.hostelOwnerEmail),
                          infoTitle('Paid by :-'),
                          infoDetail(context, guest.name),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Select Payment of',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: const Text('paymentTypes'),
                                    value: selectedPaymentType,
                                    items: paymentTypes
                                        .map((item) => DropdownMenuItem(
                                              child: Text(item,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                  )),
                                              value: item,
                                            ))
                                        .toList(),
                                    onChanged: (selectedvalue) {
                                      setState(() {
                                        selectedPaymentType =
                                            selectedvalue as String?;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (selectedPaymentType != null)
                            Column(
                              children: [
                                selectedPaymentType == 'Daywise'
                                    ? TextField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        controller: totalDaysController,
                                        decoration: InputDecoration(
                                          labelText: 'Total Days Stayed',
                                          labelStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  borderSide: const BorderSide(
                                                      color: Colors.red,
                                                      width: 2.0)),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            monthofPayment != null
                                                ? monthofPayment!
                                                : 'Pick Month',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                monthPicker();
                                              },
                                              icon: const Icon(
                                                Icons.calendar_today,
                                                color: Colors.blue,
                                              ))
                                        ],
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  controller: totalAmountController,
                                  decoration: InputDecoration(
                                    labelText: 'Total Amount Paid',
                                    labelStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2.0)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2.0)),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (selectedPaymentType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Please Select Payment Type')));
                          return;
                        }
                        if (selectedPaymentType == 'Monthlywise' &&
                            monthofPayment == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content:
                                      Text('Please Select pick the Month')));
                          return;
                        }

                        if (selectedPaymentType == 'Daywise' &&
                            totalDaysController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Please Fill the Total Days')));
                          return;
                        }
                        if (totalAmountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content:
                                      Text('Please Fill the Paid Amount')));
                          return;
                        }
                        final time = Timestamp.now();
                        String receiptId =
                            time.millisecondsSinceEpoch.toString();

                        setState(() {
                          newReciept.receiptId = receiptId;
                          newReciept.receiverId = guest.guestId;
                          newReciept.receiverRoomNum = guest.roomNum.toString();
                          newReciept.receiverName = guest.name;
                          newReciept.receiverPhone = guest.phoneNum;
                          newReciept.paidAmount =
                              int.parse(totalAmountController.text);
                          newReciept.paymentOf =
                              selectedPaymentType == 'Daywise'
                                  ? '${totalDaysController.text} days'
                                  : monthofPayment!;
                          newReciept.paidOn = time;
                          newReciept.hostelId = guest.hostelId;
                          newReciept.givenBy = sender.name;
                        });

                        final pdffile =
                            await PdfInvoiceApi.generate(newReciept, hostel);
                        setState(() {
                          pdf = pdffile;
                          isCompleted = true;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.amber),
                        child: const Center(
                          child: Text(
                            'Send Receipt',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final guest = Provider.of<GuestProvider>(context).guestById(widget.guestId);
    final hostel =
        Provider.of<HostelProvider>(context).findById(guest.hostelId);
    final sender =
        Provider.of<MaintainerProvider>(context).findById(currentUserId!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paid Receipt'),
        actions: [
          if (isCompleted == true)
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  var receiptFile = FirebaseStorage.instance
                      .ref()
                      .child('Receipts')
                      .child('${newReciept.receiptId}.pdf');
                  UploadTask task = receiptFile.putFile(pdf);
                  TaskSnapshot snapshot = await task;
                  final receiptImageUrl = await snapshot.ref.getDownloadURL();
                  setState(() {
                    newReciept.receiptImage = receiptImageUrl;
                  });
                  try {
                    Provider.of<PaidReceiptProvider>(context, listen: false)
                        .addReciept(context, newReciept);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Success')));
                    Navigator.pop(context);
                    setState(() {
                      isLoading = false;
                    });
                  } on PlatformException catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('${err.message}')));
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                icon: const Icon(Icons.check),
                label: const Text('Done'))
        ],
      ),
      body: Stack(
        children: [
          isCompleted == true
          ? pdfView()
          : formView(guest, hostel, sender),
          if (isLoading == true)
            Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: SizedBox(height: 100, child: LoadingView()))),
        ],
      )
    );
  }
}
