import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payinguest/provider/maintainer.dart';
import 'package:payinguest/screens/Hostel/dashboard.dart';
import 'package:payinguest/screens/Owner/register_hostel.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/screens/image_view.dart';
import 'package:payinguest/widgets/app_drawer.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class OwnerScreen extends StatefulWidget {
  const OwnerScreen({Key? key}) : super(key: key);

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  String? ownerId;
  String? ownerName;
  String? ownerEmail;
  String? ownerNumber;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    ownerId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('Maintainers')
        .doc(ownerId)
        .get()
        .then((DocumentSnapshot snapshot) {
      ownerName = snapshot.get('name');
      ownerEmail = snapshot.get('email');
      ownerNumber = snapshot.get('phoneNumber');
    });
    Provider.of<HostelProvider>(context).ownerHostels(context, ownerId!);
    Provider.of<MaintainerProvider>(context, listen: false)
        .maintainerData(context, ownerId!);
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  Widget myhostels(List<Hostel> hostels) {
    return hostels.isEmpty
        ? const Center(
            child: SizedBox(
              height: 100,
              child: Text('Please Add Hostel'),
            ),
          )
        : ListView(
            children: hostels.map((hostel) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue, width: 10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ImageView(imageUrl: hostel.hostelImage)));
                        },
                        child: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                          imageUrl: hostel.hostelImage,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                                height: 70, width: 70, child: LoadingView()),
                          ),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      ),
                      Flexible(
                          child: Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hostel.hostelName,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              hostel.livingType == 0
                                  ? 'Boys Hostel'
                                  : hostel.livingType == 1
                                      ? 'Girls Hostel'
                                      : 'Co-Live Hostel',
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                    ),
                                    onPressed: hostel.isPremium
                                        ? () {
                                            Navigator.of(context).push(
                                                PageTransition(
                                                    duration: const Duration(
                                                        milliseconds: 800),
                                                    reverseDuration:
                                                        const Duration(
                                                            milliseconds: 800),
                                                    childCurrent: widget,
                                                    child: DashBoard(
                                                      hostelId: hostel.hostelId,
                                                    ),
                                                    type: PageTransitionType
                                                        .fade));
                                          }
                                        : null,
                                    child: const Text('View Details')),
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ));
            }).toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    final hostels = Provider.of<HostelProvider>(context).allHostels;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Owner'),
        ),
        floatingActionButton: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
            ),
          ),
          child: const Text(
            'Add Hostel',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegistrationPage(
                      ownerId: ownerId!,
                      ownerName: ownerName!,
                      ownerEmail: ownerEmail!,
                      ownernumber: ownerNumber!,
                    )));
          },
        ),
        drawer: const AppDrawer(),
        body: isLoading == true
            ? const Center(
                child: SizedBox(
                  height: 100,
                  child: LoadingView(),
                ),
              )
            : myhostels(hostels));
  }
}
