import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payinguest/common/analytics_paint.dart';
import 'package:payinguest/common/background_paint.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/provider/room.dart';
import 'package:payinguest/screens/Hostel/hostel_details.dart';
import 'package:payinguest/screens/receipts/paid_receipts.dart';
import 'package:payinguest/screens/vacatedGuests/vacated_guests.dart';
import 'package:payinguest/widgets/app_drawer.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import '../HostelGuests/all_guests.dart';
import '../rooms/hostel_rooms.dart';
import '../HostelGuests/new_guests.dart';

class DashBoard extends StatefulWidget {
  final String hostelId;
  const DashBoard(
      {Key? key,
      required this.hostelId,})
      : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String? userId;
  bool isLoading = false;
  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser?.uid;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<RoomSharingProvider>(context)
        .getRooms(context, widget.hostelId);
    Provider.of<GuestProvider>(context).myGuests(context, widget.hostelId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int strength = Provider.of<RoomSharingProvider>(context).totalStrength;
    List guests = Provider.of<GuestProvider>(context).alljoinedguests();
    int joined = guests.length;
    final hostel = Provider.of<HostelProvider>(
      context,
      listen: false,
    ).findById(widget.hostelId);
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffE7EDF7),
          drawer: const AppDrawer(),
          body: CustomPaint(
            painter: BackgroundPainter(),
            child: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green, width: 4),
                                  borderRadius: BorderRadius.circular(50)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: hostel.hostelImage,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: LoadingView()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                child: Text(
                              hostel.hostelName,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CustomPaint(
                            painter: AnalyticsPaint(),
                            child: Row(children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xff7D67F9)
                                        .withOpacity(0.6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '$strength',
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'Strength',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xff7D67F9)
                                        .withOpacity(0.6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '$joined',
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'Filled',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xff7D67F9)
                                        .withOpacity(0.6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${strength - joined}',
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'Vacancies',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                            ]),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              duration: const Duration(milliseconds: 800),
                              reverseDuration:
                                  const Duration(milliseconds: 800),
                              childCurrent: widget,
                              child: PaidReceipts(
                                hostelId: hostel.hostelId,
                              ),
                              type: PageTransitionType.fade));
                        },
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: const Center(
                                child: Text('Paid Receipts',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              duration: const Duration(milliseconds: 800),
                              reverseDuration:
                                  const Duration(milliseconds: 800),
                              childCurrent: widget,
                              child: NewGuests(
                                hostelId: hostel.hostelId,
                              ),
                              type: PageTransitionType.fade));
                        },
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: const Center(
                                child: Text('New Guests',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              duration: const Duration(milliseconds: 800),
                              reverseDuration:
                                  const Duration(milliseconds: 800),
                              childCurrent: widget,
                              child: HostelRooms(
                                hostelId: hostel.hostelId,
                              ),
                              type: PageTransitionType.fade));
                        },
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: const Center(
                                child: Text('Hostel Rooms',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              duration: const Duration(milliseconds: 800),
                              reverseDuration:
                                  const Duration(milliseconds: 800),
                              childCurrent: widget,
                              child: AllGuests(
                                hostelId: hostel.hostelId,
                              ),
                              type: PageTransitionType.fade));
                        },
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: const Center(
                                child: Text('Joined Guests',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              duration: const Duration(milliseconds: 800),
                              reverseDuration:
                                  const Duration(milliseconds: 800),
                              childCurrent: widget,
                              child: VacatedGuests(
                                hostelId: hostel.hostelId,
                              ),
                              type: PageTransitionType.fade));
                        },
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: const Center(
                                child: Text('Vacated Guests',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      if (hostel.hostelOwnerId == userId)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageTransition(
                                duration: const Duration(milliseconds: 800),
                                reverseDuration:
                                    const Duration(milliseconds: 800),
                                childCurrent: widget,
                                child: HostelDetails(
                                  hostelId: hostel.hostelId,
                                ),
                                type: PageTransitionType.fade));
                          },
                          child: Card(
                            color: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              width: MediaQuery.of(context).size.width,
                              height: 70,
                              child: const Center(
                                  child: Text('Hostel Details',
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(Icons.arrow_back)),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
