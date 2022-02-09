import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:payinguest/provider/paid_receipt.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReceiptView extends StatefulWidget {
  final String receiptId;
  const ReceiptView({Key? key, required this.receiptId}) : super(key: key);

  @override
  State<ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  bool isLoading = false;
  
  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final receipt =
        Provider.of<PaidReceiptProvider>(context).recieptById(widget.receiptId);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                if (await requestPermission(Permission.storage)) {
                  final temp =
                      await ExternalPath.getExternalStoragePublicDirectory(
                          ExternalPath.DIRECTORY_DOWNLOADS);
                  final fullPath = '$temp/${receipt.receiptId}.pdf';
                  final response = await Dio().get(
                    receipt.receiptImage,
                    options: Options(
                        responseType: ResponseType.bytes,
                        followRedirects: false,
                        validateStatus: (status) {
                          return status! < 500;
                        }),
                  );

                  //write in download folder
                  File file = File(fullPath);
                  var raf = file.openSync(mode: FileMode.write);
                  raf.writeFromSync(response.data);
                  await raf.close();
                  setState(() {
                    isLoading = false;
                  });
                  await Share.shareFiles(
                    [file.path],
                  );
                  await File(file.path).delete();
                }
              },
              icon: const Icon(Icons.share)),
          IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                if (await requestPermission(Permission.storage)) {
                  final temp =
                      await ExternalPath.getExternalStoragePublicDirectory(
                          ExternalPath.DIRECTORY_DOWNLOADS);
                  final fullPath = '$temp/${receipt.receiptId}.pdf';
                  final response = await Dio().get(
                    receipt.receiptImage,
                    options: Options(
                        responseType: ResponseType.bytes,
                        followRedirects: false,
                        validateStatus: (status) {
                          return status! < 500;
                        }),
                  );

                  //write in download folder
                  File file = File(fullPath);
                  var raf = file.openSync(mode: FileMode.write);
                  raf.writeFromSync(response.data);
                  await raf.close();
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Downloaded...'),
                    backgroundColor: Colors.green,
                  ));
                }
              },
              icon: const Icon(Icons.download)),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SfPdfViewer.network(
              receipt.receiptImage,
            ),
          ),
          if (isLoading == true)
            Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: SizedBox(height: 100, child: LoadingView()))),
        ],
      ),
    );
  }
}
