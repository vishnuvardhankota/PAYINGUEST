import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:provider/provider.dart';

import 'hostel_view.dart';

class CitiesBased extends StatefulWidget {
  final String selectedCity;
  const CitiesBased({Key? key, required this.selectedCity}) : super(key: key);

  @override
  _CitiesBasedState createState() => _CitiesBasedState();
}

class _CitiesBasedState extends State<CitiesBased> {
  @override
  void didChangeDependencies() {
    Provider.of<HostelProvider>(context)
        .hostelsBySelectedCity(context, widget.selectedCity);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final hostels =
        Provider.of<HostelProvider>(context).byCityName(widget.selectedCity);
    return hostels.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Center(
              child: Text(
                'No Hostels registered in ${widget.selectedCity}',
                overflow: TextOverflow.fade,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : Column(
            children: hostels.map((hostel) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: const EdgeInsets.only(left: 7, top: 7),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.orange, width: 3)),
                                child: CachedNetworkImage(
                                  height: 150,
                                  width: 130,
                                  fit: BoxFit.fill,
                                  imageUrl: hostel.hostelImage,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => HostelView(
                                                  hostelId: hostel.hostelId,
                                                  managerId:
                                                      hostel.hostelManagerId,
                                                )));
                                  },
                                  child: const Text('View Details')),
                            ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
                                      ),
                                      Flexible(
                                        child: Text(hostel.hostelMainArea,
                                            overflow: TextOverflow.fade,
                                            style:
                                                const TextStyle(fontSize: 18)),
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
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                    Text(' ₹ ${hostel.monthlyBasis} Onwards',
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
                                      ' Daily Basis',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(' ₹ ${hostel.dailyBasis} Onwards',
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
                  ),
                ),
              );
            }).toList(),
          );
  }
}
