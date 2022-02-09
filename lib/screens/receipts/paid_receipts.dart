import 'package:flutter/material.dart';
import 'package:payinguest/provider/paid_receipt.dart';
import 'package:payinguest/screens/receipts/receipt_view.dart';
import 'package:provider/provider.dart';

class PaidReceipts extends StatefulWidget {
  final String hostelId;
  const PaidReceipts({Key? key, required this.hostelId}) : super(key: key);

  @override
  State<PaidReceipts> createState() => _PaidReceiptsState();
}

class _PaidReceiptsState extends State<PaidReceipts> {
  @override
  void didChangeDependencies() {
    Provider.of<PaidReceiptProvider>(context)
        .getReceipts(context, widget.hostelId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final paidReceipts = Provider.of<PaidReceiptProvider>(context).allReceipts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paid Receipts'),
      ),
      body: paidReceipts.isEmpty
          ? const Center(
              child: Text('No Receipts'),
            )
          : ListView(
              children: paidReceipts.map((receipt) {
                return Card(
                  elevation: 5,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Paid By :- ${receipt.receiverName}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Amount :- RS.${receipt.paidAmount}'),
                              IconButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReceiptView(
                                                receiptId: receipt.receiptId)));
                                  },
                                  icon: const Icon(Icons.share))
                            ],
                          )
                        ],
                      )),
                );
              }).toList(),
            ),
    );
  }
}
