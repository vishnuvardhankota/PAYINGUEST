import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/provider/paid_receipt.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generate(PaidReceipt receipt, Hostel hostel) async {
    final pdf = Document();
    final image =
        (await rootBundle.load('images/stamp.png')).buffer.asUint8List();
    final background =
        (await rootBundle.load('images/invbg.png')).buffer.asUint8List();

    final date =
        DateTime.fromMillisecondsSinceEpoch(receipt.paidOn.seconds * 1000);
    String paidOn = DateFormat().add_yMMMd().format(date);

    pdf.addPage(MultiPage(
      pageTheme: PageTheme(
        pageFormat: PdfPageFormat.a4,
        buildBackground: (context) => pw.FullPage(
            ignoreMargins: true, child: pw.Image(pw.MemoryImage(background))),
      ),
      maxPages: 1,
      build: (context) => [
        buildHeader(),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Container(
            width: PdfPageFormat.a4.width,
            child: Text('Receipt Id:- ${receipt.receiptId}',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        Container(
            width: PdfPageFormat.a4.width,
            child: Text('Paid on:- $paidOn',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildBody(hostel),
        buildGuestDetails(receipt),
        SizedBox(height: 25),
        buildInvoice(receipt),
        SizedBox(height: 25),
        buildReceiptStatus(receipt, image)
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader() {
    return Container(
        width: PdfPageFormat.a4.availableWidth,
        child: Text('RECEIPT',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: PdfColors.blue),
            textAlign: TextAlign.center));
  }

  static Widget buildBody(Hostel hostel) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(hostel.hostelName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      buildHostelInfo(hostel),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ]);
  }

  static Widget buildHostelInfo(Hostel hostel) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Address -', style: const TextStyle(fontSize: 20)),
        Container(
            width: PdfPageFormat.a4.width * 0.4,
            child: Text(
                '${hostel.hostelPostalCode}, ${hostel.hostelStreet}, ${hostel.hostelMainArea}, ${hostel.hostelCity}, ${hostel.hostelState}',
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 18))),
        SizedBox(height: 15),
        Text('Phone - ${hostel.hostelOwnerNumber}',
            style: const TextStyle(fontSize: 18)),
      ]),
    );
  }

  static Widget buildGuestDetails(PaidReceipt receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Billing to',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Divider(thickness: 1, color: PdfColors.black),
        Text(receipt.receiverName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Phone No:- ${receipt.receiverPhone}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
      ],
    );
  }

  static Widget buildInvoice(PaidReceipt receipt) {
    final headers = [
      'Room No.',
      'Payment of',
      'Rent',
    ];
    final data = [
      [
        receipt.receiverRoomNum,
        receipt.paymentOf,
        'Rs.${receipt.paidAmount}',
      ]
    ];

    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        cellStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        headerDecoration: const BoxDecoration(color: PdfColors.grey),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
        });
  }

  static Widget buildReceiptStatus(PaidReceipt receipt, Uint8List image) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pw.Image(pw.MemoryImage(image),
              height: 100, width: 100, fit: BoxFit.contain),
          Column(children: [
            Text('Given By -',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black)),
            Text(receipt.givenBy,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: PdfColors.red)),
          ])
        ]);
  }

  static Widget buildFooter() {
    return Container(
        width: PdfPageFormat.a4.availableWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(),
            SizedBox(height: 2 * PdfPageFormat.mm),
            Text('PAYINGUEST',
                style: pw.TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.blue,
                    fontSize: 25)),
          ],
        ));
  }
}
