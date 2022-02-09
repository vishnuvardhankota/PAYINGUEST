import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/screens/Hostel/application.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import 'guest_details.dart';

class NewGuests extends StatefulWidget {
  final String hostelId;
  const NewGuests(
      {Key? key, required this.hostelId,})
      : super(key: key);

  @override
  State<NewGuests> createState() => _NewGuestsState();
}

class _NewGuestsState extends State<NewGuests> {
  @override
  Widget build(BuildContext context) {
    final newGuests = Provider.of<GuestProvider>(context).allnewGuests();
    final hostel = Provider.of<HostelProvider>(context, listen: false)
        .findById(widget.hostelId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Guests'),
      ),
      floatingActionButton: ElevatedButton.icon(
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
        icon: const Icon(Icons.person_add),
        label: const Text(
          'Add Guest',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ApplicationForm(
                          hostelId: hostel.hostelId,
                        )));
              },
      ),
      body: newGuests.isEmpty
          ? const Center(
              child: Text(
                'No Any New Guests Are There',
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            )
          : ListView(
              children: newGuests.map((guest) {
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
                              width: 100,
                              height: 100,
                              imageUrl: guest.profile,
                              fit: BoxFit.fitWidth,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
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
            ),
    );
  }
}
