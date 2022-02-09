import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/room.dart';
import 'package:payinguest/provider/vacatedguest.dart';
import 'package:payinguest/screens/receipts/new_receipt_page.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import '../image_view.dart';

class GuestDetails extends StatefulWidget {
  final String guestId;
  const GuestDetails({Key? key, required this.guestId}) : super(key: key);

  @override
  State<GuestDetails> createState() => _GuestDetailsState();
}

class _GuestDetailsState extends State<GuestDetails> {
  int? newRoomNum;
  bool isRequestToVacate = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController rentController = TextEditingController();

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

  selectingNewRoom(BuildContext context, Guest guest) {
    final rooms =
        Provider.of<RoomSharingProvider>(context, listen: false).allRooms;
    List<RoomSharing> nonFullRooms() {
      return rooms
          .where((room) =>
              room.typeSharing !=
              Provider.of<GuestProvider>(context, listen: false)
                  .guestsByRoomNum(room.roomNum)
                  .length)
          .toList();
    }

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      newRoomNum = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
            title: const Text(
              'Select New Room',
              style: TextStyle(color: Colors.red),
            ),
            content: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: nonFullRooms().map((roomnumm) {
                    return RadioListTile(
                        title: Text(
                          '${roomnumm.roomNum}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: roomnumm.roomNum,
                        groupValue: newRoomNum,
                        selected: newRoomNum == roomnumm.roomNum,
                        onChanged: (int? value) {
                          setState(() {
                            newRoomNum = value;
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                newRoomNum = null;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No')),
                                        ElevatedButton(
                                            onPressed: () {
                                              guest.roomNum == 0
                                                  ? Provider.of<GuestProvider>(
                                                          context,listen: false)
                                                      .addGuestToRoom(
                                                          context,
                                                          newRoomNum!,
                                                          guest.hostelId,
                                                          guest.guestId,
                                                          int.parse(
                                                              rentController
                                                                  .text))
                                                  : Provider.of<GuestProvider>(
                                                          context,
                                                          listen: false)
                                                      .changeRoom(
                                                          context,
                                                          newRoomNum!,
                                                          guest.hostelId,
                                                          guest.guestId);
                                              setState(() {
                                                newRoomNum = null;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Yes'))
                                      ],
                                      title: const Text(
                                        'Are You Sure?',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content: Text(
                                        'You want to change Guest to Room No. $newRoomNum',
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ));
                                });
                          });
                        });
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final guest = Provider.of<GuestProvider>(context).guestById(widget.guestId);

    return Scaffold(
        backgroundColor: const Color(0xffC8D9EB),
        appBar: AppBar(
          title: const Text('Guest Profile'),
        ),
        // ignore: unnecessary_null_comparison
        body: guest == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ImageView(
                                                imageUrl: guest.profile)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: CachedNetworkImage(
                                      width: 130,
                                      height: 130,
                                      imageUrl: guest.profile,
                                      fit: BoxFit.fitWidth,
                                      placeholder: (context, url) =>
                                          const Center(child: LoadingView()),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.error)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  guest.name,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: guest.roomNum == 0
                            ? Center(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        selectingNewRoom(context, guest);
                                      }
                                    },
                                    child: const Text(
                                      'Add To Room',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Room No:- ${guest.roomNum}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        selectingNewRoom(context, guest);
                                      },
                                      child: const Text(
                                        'Change',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                      ),
                      if (guest.roomNum != 0)
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Vacate Guest',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isRequestToVacate =
                                                !isRequestToVacate;
                                          });
                                        },
                                        child: const Text(
                                          'Vacate',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                                if (isRequestToVacate == true)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Are You Sure?',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isRequestToVacate = false;
                                                  });
                                                },
                                                child: const Text('No')),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                ),
                                                onPressed: () {
                                                  try {
                                                    Provider.of<VacatedGuestProvider>(
                                                            context,
                                                            listen: false)
                                                        .vacateGuest(
                                                            context,
                                                            guest,
                                                            guest.hostelId);
                                                    Navigator.pop(context);
                                                  } catch (error) {
                                                    rethrow;
                                                  }
                                                },
                                                child: const Text('Yes'))
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                      if (guest.roomNum != 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Send New 👉',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewReceipt(
                                                  guestId: guest.guestId,
                                                )));
                                  },
                                  child: const Text(
                                    'Paid Receipt',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                      infoTitle('Staying :- '),
                      infoDetail(context,
                          guest.stayingBase == 0 ? 'Monthly wise' : 'Day wise'),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Rent :- '),
                      guest.roomNum == 0
                          ? Form(
                              key: formKey,
                              child: Container(
                                child: TextFormField(
                                  controller: rentController,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please enter Guest Rent Fee";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(fontSize: 20),
                                    labelText: guest.stayingBase == 0
                                        ? 'Monthly Rent'
                                        : 'Daily Rent',
                                    fillColor: Colors.white,
                                    filled: true,
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
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  )
                                ]),
                              ),
                            )
                          : infoDetail(context, '${guest.rent}'),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Gender :- '),
                      infoDetail(
                          context, guest.gender == 0 ? 'Male' : 'Female'),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Age :- '),
                      infoDetail(context, guest.age),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Date of Birth :- '),
                      infoDetail(context, guest.guestDOB),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Phone Number :- '),
                      infoDetail(context, guest.phoneNum),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Parent Phone Number :- '),
                      infoDetail(context, guest.parentPhoneNum),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Email :- '),
                      infoDetail(context, guest.email),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Address :- '),
                      infoDetail(context, guest.address),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Working Address :- '),
                      infoDetail(context, guest.workingPlace),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Graduation :- '),
                      infoDetail(context, guest.graduation),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Joined on :- '),
                      infoDetail(context, guest.guestDOJ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ImageView(
                                        imageUrl: guest.aadharFront)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: CachedNetworkImage(
                                  width: 130,
                                  height: 130,
                                  imageUrl: guest.aadharFront,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const Center(child: LoadingView()),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ImageView(imageUrl: guest.aadharBack)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: CachedNetworkImage(
                                  width: 130,
                                  height: 130,
                                  imageUrl: guest.aadharBack,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const Center(child: LoadingView()),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                            if (guest.idCard != null)
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ImageView(imageUrl: guest.idCard!)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: CachedNetworkImage(
                                    width: 130,
                                    height: 130,
                                    imageUrl: guest.idCard!,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                        const Center(child: LoadingView()),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.error)),
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
