import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:payinguest/provider/vacatedguest.dart';
import 'package:payinguest/screens/vacatedGuests/vacated_guest_detail.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class VacatedGuests extends StatefulWidget {
  final String hostelId;
  const VacatedGuests({
    Key? key,
    required this.hostelId,
  }) : super(key: key);

  @override
  State<VacatedGuests> createState() => _VacatedGuestsState();
}

class _VacatedGuestsState extends State<VacatedGuests> {
  @override
  void didChangeDependencies() {
    Provider.of<VacatedGuestProvider>(context)
        .myVacatedGuests(context, widget.hostelId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final vacatedGuests =
        Provider.of<VacatedGuestProvider>(context).allVacatedGuests;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacated Guests'),
      ),
      body: vacatedGuests.isEmpty
          ? const Center(
              child: Text(
                'No Vacated Guests Are There',
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            )
          : ListView(
              children: vacatedGuests.map((vacatedGuest) {
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
                              imageUrl: vacatedGuest.profile,
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
                                    vacatedGuest.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(
                                                    vacatedGuest.phoneNum);
                                          },
                                          icon: const Icon(Icons.call),
                                          label: const Text('Call')),
                                      const SizedBox(
                                        width: 10,
                                      ),
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
                                                        VacatedGuestDetails(
                                                          vacatedGuestId:
                                                              vacatedGuest
                                                                  .guestId,
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
