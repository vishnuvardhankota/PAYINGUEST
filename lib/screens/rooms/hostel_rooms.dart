import 'package:flutter/material.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/provider/room.dart';
import 'package:payinguest/screens/rooms/room_detail.dart';
import 'package:provider/provider.dart';

class HostelRooms extends StatefulWidget {
  final String hostelId;
  const HostelRooms({Key? key, required this.hostelId}) : super(key: key);

  @override
  State<HostelRooms> createState() => _HostelRoomsState();
}

class _HostelRoomsState extends State<HostelRooms> {
  TextEditingController roomController = TextEditingController();
  TextEditingController sharingController = TextEditingController();
  final newRoom = RoomSharing(
      roomId: '',
      roomNum: 0,
      typeSharing: 0,
      hostelId: '',
      ownerId: '',
      managerId: '');
  @override
  Widget build(BuildContext context) {
    final rooms = Provider.of<RoomSharingProvider>(context).allRooms;
    final roomnums = rooms.map((room) => room.roomNum).toList();
    final hostel = Provider.of<HostelProvider>(
      context,
      listen: false,
    ).findById(widget.hostelId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Rooms'),
        actions: [
          ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
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
                              child: const Text('Add'),
                              onPressed: () async {
                                if (roomnums
                                    .contains(int.parse(roomController.text))) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Room No. Already Added...")));
                                  setState(() {
                                    roomController.clear();
                                    sharingController.clear();
                                  });
                                  Navigator.pop(context);
                                  return;
                                }
                                if (int.parse(sharingController.text) == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Sharing type Not Equal to 0")));
                                  setState(() {
                                    roomController.clear();
                                    sharingController.clear();
                                  });
                                  Navigator.pop(context);
                                  return;
                                }
                                final time = DateTime.now().toString();
                                setState(() {
                                  newRoom.roomId = time;
                                  newRoom.roomNum =
                                      int.parse(roomController.text);
                                  newRoom.typeSharing =
                                      int.parse(sharingController.text);
                                  newRoom.ownerId = hostel.hostelOwnerId;
                                  newRoom.managerId = hostel.hostelManagerId;
                                });
                                try {
                                  await Provider.of<RoomSharingProvider>(
                                          context,
                                          listen: false)
                                      .addRoom(
                                          context, newRoom, widget.hostelId);
                                  setState(() {
                                    roomController.clear();
                                    sharingController.clear();
                                  });
                                } catch (error) {
                                  rethrow;
                                }
                                Navigator.pop(context);
                              })
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Room'))
        ],
      ),
      body: rooms.isEmpty
          ? const Center(
              child: Text(
                'Please Add Rooms',
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: rooms.map((room) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoomDetails(
                                    roomId: room.roomId,
                                  )));
                    },
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Center(child: Image.asset('images/Room.jpg')),
                          Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Room No.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                '${room.roomNum}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                          if (Provider.of<GuestProvider>(context)
                              .guestsByRoomNum(room.roomNum)
                              .isEmpty)
                            Positioned(
                                right: -10,
                                top: -10,
                                child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Are You Sure!'),
                                              content: Text(
                                                  'Do you want to Remove Room No. ${room.roomNum}'),
                                              actions: [
                                                ElevatedButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () {
                                                      Provider.of<RoomSharingProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteRoom(context, room,
                                                              widget.hostelId);
                                                      Navigator.pop(context);
                                                    }),
                                                ElevatedButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    )))
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
