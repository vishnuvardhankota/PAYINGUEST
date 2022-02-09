import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/room.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';
import '../HostelGuests/guest_details.dart';

class RoomDetails extends StatefulWidget {
  final String roomId;
  const RoomDetails({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  TextEditingController roomController = TextEditingController();
  TextEditingController sharingController = TextEditingController();

  Future<void> updateRoom(RoomSharing room, RoomSharing newRoom) async {
    if (roomController.text.isEmpty) {
      return;
    }
    if (sharingController.text.isEmpty) {
      return;
    }
    final rooms =
        Provider.of<RoomSharingProvider>(context, listen: false).allRooms;
    final roomnums = rooms.map((roo) => roo.roomNum).toList();
    roomnums.remove(room.roomNum);
    if (roomnums.contains(int.parse(roomController.text))) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Room No. Already Added...")));
      setState(() {
        roomController.clear();
        sharingController.clear();
      });
      Navigator.pop(context);
      return;
    }
    if (int.parse(sharingController.text) == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sharing type Not Equal to 0")));
      setState(() {
        roomController.clear();
        sharingController.clear();
      });
      Navigator.pop(context);
      return;
    }
    setState(() {
      newRoom.roomNum = int.parse(roomController.text);
      newRoom.typeSharing = int.parse(sharingController.text);
    });
    try {
      await Provider.of<RoomSharingProvider>(context, listen: false)
          .updateRoom(context, newRoom, room.hostelId);
      setState(() {
        roomController.clear();
        sharingController.clear();
      });
    } catch (error) {
      rethrow;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final room =
        Provider.of<RoomSharingProvider>(context).roomById(widget.roomId);
    final guests =
        Provider.of<GuestProvider>(context).guestsByRoomNum(room.roomNum);
    final newRoom = RoomSharing(
        roomId: room.roomId,
        roomNum: 0,
        typeSharing: 0,
        hostelId: room.hostelId,
        ownerId: room.ownerId,
        managerId: room.managerId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Room No. ${room.roomNum}'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              roomController.text = room.roomNum.toString();
              sharingController.text = room.typeSharing.toString();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: TextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: roomController,
                        decoration:
                            const InputDecoration(labelText: 'Room No.'),
                      ),
                      content: TextField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        controller: sharingController,
                        decoration: const InputDecoration(
                          labelText: 'Sharing type',
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            child: const Text('Update'),
                            onPressed: () {
                              updateRoom(room, newRoom);
                            })
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.edit),
            label: const Text(
              'Room',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              '${room.typeSharing} Sharing',
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: room.typeSharing,
                itemBuilder: (context, snapshot) {
                  return Image.asset('images/bed.png');
                },
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ),
            Text(
              'Guests(${guests.length})',
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: guests.map((guest) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Material(
                            child: CachedNetworkImage(
                              height: 100,
                              width: 100,
                              imageUrl: guest.profile,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  const Center(child: LoadingView()),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                            borderRadius: BorderRadius.circular(25),
                            clipBehavior: Clip.hardEdge,
                          ),
                          Flexible(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    guest.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(guest.phoneNum);
                                          },
                                          icon: const Icon(Icons.call),
                                          label: const Text('Call')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GuestDetails(
                                                          guestId:
                                                              guest.guestId,
                                                        )));
                                          },
                                          child: const Text('View'))
                                    ],
                                  )
                                ],
                              ),
                              margin: const EdgeInsets.only(left: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
