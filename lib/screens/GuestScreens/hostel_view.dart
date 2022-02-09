import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/screens/Hostel/application.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import '../image_view.dart';

class HostelView extends StatefulWidget {
  final String hostelId;
  final String managerId;
  const HostelView({
    Key? key,
    required this.hostelId,
    required this.managerId,
  }) : super(key: key);

  @override
  State<HostelView> createState() => _HostelViewState();
}

class _HostelViewState extends State<HostelView> {
  String? managerName;
  String? managerNumber;
  @override
  void didChangeDependencies() {
    FirebaseFirestore.instance
        .collection('Maintainers')
        .doc(widget.managerId)
        .get()
        .then((DocumentSnapshot snapshot) {
      managerName = snapshot.get('name');
      managerNumber = snapshot.get('phoneNumber');
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final hostel =
        Provider.of<HostelProvider>(context).findById(widget.hostelId);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: hostel.hostelImage,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostel.hostelName,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  const Text('Manager -',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(hostel.hostelManagerName,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Address -',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        Flexible(
                          child: Text(
                              '${hostel.hostelPostalCode},${hostel.hostelStreet},${hostel.hostelMainArea},${hostel.hostelCity},${hostel.hostelState},',
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Facilities Provided -',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  if (hostel.facilities.isNotEmpty)
                    Container(
                        margin: const EdgeInsets.only(
                            right: 10, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: hostel.facilities.map((facility) {
                            return Text(
                              facility,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Hostel Photos -',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  if (hostel.hostelImages.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: hostel.hostelImages.map((image) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ImageView(
                                                imageUrl: image)));
                            },
                            child: CachedNetworkImage(
                              fit: BoxFit.fitHeight,
                              imageUrl: image,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                    height: 70, width: 70, child: LoadingView()),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Rents Starts on -',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          decoration: TextDecoration.underline)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ' Daily Basis',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(' ₹ ${hostel.dailyBasis} Onwards',
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ' Monthly Basis',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(' ₹ ${hostel.monthlyBasis} Onwards',
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('For More Info:-',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Contact Support',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(managerNumber ?? '',
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                      TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          onPressed: managerNumber != null
                              ? () {
                                  FlutterPhoneDirectCaller.callNumber(
                                      managerNumber!);
                                }
                              : null,
                          icon: const Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Make Call',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ApplicationForm(
                                      hostelId: hostel.hostelId,
                                    )));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: const Text('Apply to Join',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
