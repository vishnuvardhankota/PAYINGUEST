import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/screens/HostelGuests/guest_details.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class AllGuests extends StatefulWidget {
  final String hostelId;
  const AllGuests({Key? key, required this.hostelId}) : super(key: key);

  @override
  State<AllGuests> createState() => _AllGuestsState();
}

class _AllGuestsState extends State<AllGuests> {
  String textSearch = '';
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBar = TextEditingController();

  Widget buildSearchBar() {
    return Container(
      height: 40,
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBar,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  btnClearController.add(true);
                  setState(() {
                    textSearch = value;
                  });
                } else {
                  btnClearController.add(false);
                  setState(() {
                    textSearch = '';
                  });
                }
              },
              decoration:
                  const InputDecoration.collapsed(hintText: 'Search...'),
            ),
          ),
          StreamBuilder(
            stream: btnClearController.stream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return GestureDetector(
                  onTap: () {
                    searchBar.clear();
                    btnClearController.add(false);
                    setState(() {
                      textSearch = '';
                    });
                  },
                  child: const Icon(
                    Icons.clear_rounded,
                    size: 20,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  Widget allGuesst(List<Guest> allGuests) {
    return allGuests.isEmpty
        ? const Center(
            child: Text('No Guests Are There',
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.red),),
          )
        : ListView(
            shrinkWrap: true,
            children: allGuests.map((guest) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${guest.roomNum}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
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
                                                        guestId: guest.guestId,
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
          );
  }

  Widget particularGuesst(List<Guest> particular) {
    return particular.isEmpty
        ? const Center(
            child: Text('No Guests Are Found',
            overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.red),),
          )
        : ListView(
            shrinkWrap: true,
            children: particular.map((guest) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${guest.roomNum}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
                                    ElevatedButton.icon(
                                        onPressed: () async {
                                          await FlutterPhoneDirectCaller
                                              .callNumber(guest.phoneNum);
                                        },
                                        icon: const Icon(Icons.call),
                                        label: const Text('Call')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GuestDetails(
                                                        guestId: guest.guestId,
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Guests'),
      ),
      body: Column(
        children: [
          buildSearchBar(),
          textSearch.isEmpty
              ? allGuesst(Provider.of<GuestProvider>(context).alljoinedguests())
              : particularGuesst(Provider.of<GuestProvider>(context)
                  .guestsByRoomNum(int.parse(textSearch)))
        ],
      ),
    );
  }
}
