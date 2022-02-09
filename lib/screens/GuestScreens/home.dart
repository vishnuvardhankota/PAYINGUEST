import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/auth/login_page.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:provider/provider.dart';

import 'cities.dart';
import 'hostel_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String textSearch = '';
  bool isLoading = false;
  bool isTyped = false;
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBar = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

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
                    isTyped = true;
                  });
                } else {
                  btnClearController.add(false);
                  setState(() {
                    textSearch = '';
                    isTyped = false;
                  });
                }
              },
              decoration: const InputDecoration.collapsed(
                  hintText: 'Enter Postal Code...'),
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
                      isTyped = false;
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
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  Widget buildItem(BuildContext context, Hostel hostel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 7, top: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 3)),
                      child: CachedNetworkImage(
                        height: 150,
                        width: 130,
                        fit: BoxFit.fill,
                        imageUrl: hostel.hostelImage,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                        child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hostel.hostelName,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                Flexible(
                                  child: Text(hostel.hostelMainArea,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                ' Monthly Basis',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
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
                    ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Daily Basis',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '₹ ${hostel.dailyBasis} Onwards',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HostelView(
                                  hostelId: hostel.hostelId,
                                  managerId: hostel.hostelManagerId,
                                )));
                      },
                      child: const Text('View Details')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static final List<String> cityNames = [
    'Hyderabad',
    'Thiruvananthapur',
    'Gurgaon',
    'Mysore',
    'Bangalore',
    'Vijaywada',
    'Visakhapatnam',
    'Ankleswar',
    'Kochi',
    'Pune',
    'Mumbai',
    'Chennai',
    'Kolkata',
    'Noida',
    'Goa',
    'Kakinada',
    'Delhi',
    'Guntur',
  ];

  String? selectedCity;
  Widget searchByText() {
    final hostels =
        Provider.of<HostelProvider>(context).byPostalCode(textSearch);
    return hostels.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Text('No Hostels Found in $textSearch',
              overflow: TextOverflow.fade,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            ))
        : Column(
            children:
                hostels.map((hostel) => buildItem(context, hostel)).toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd2dadf),
      appBar: AppBar(
        title: const Text('PAYIN GUEST'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        label: const Text('Register Hostel'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Selecy City',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: const Text('Cities'),
                      value: selectedCity,
                      items: cityNames
                          .map((item) => DropdownMenuItem(
                                child: Text(item,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    )),
                                value: item,
                              ))
                          .toList(),
                      onChanged: (selectedvalue) {
                        setState(() {
                          selectedCity = selectedvalue as String?;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (selectedCity != null) buildSearchBar(),
            isTyped == true
                ? searchByText()
                : selectedCity == null
                    ? const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text('Please Select the City on Top'),
                      )
                    : CitiesBased(
                        selectedCity: selectedCity!,
                      )
          ],
        ),
      ),
    );
  }
}
