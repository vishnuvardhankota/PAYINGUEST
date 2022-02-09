import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class HostelDetails extends StatelessWidget {
  final String hostelId;
  const HostelDetails({Key? key, required this.hostelId}) : super(key: key);
  Widget tile(BuildContext context, String title, void Function() onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentuserId = FirebaseAuth.instance.currentUser?.uid;
    final hostel = Provider.of<HostelProvider>(
      context,
    ).findById(hostelId);
    return Scaffold(
      backgroundColor: const Color(0xffC8D9EB),
      appBar: AppBar(
        title: const Text('Hostel Details'),
        actions: [
          ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Edit'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: CachedNetworkImage(
                    height: 400,
                    fit: BoxFit.fill,
                    imageUrl: hostel.hostelImage,
                    placeholder: (context, url) => const Center(
                      child:
                          SizedBox(height: 70, width: 70, child: LoadingView()),
                    ),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              Text(
                hostel.hostelName,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const Text(
                'Living Type',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  hostel.livingType == 0
                      ? 'Boys'
                      : hostel.livingType == 1
                          ? 'Girls'
                          : 'CO-Live',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              const Text(
                'Hostel Manager',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              hostel.hostelManagerId == currentuserId
                  ? Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add Manager',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.person_add),
                              label: const Text('Add'))
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        hostel.hostelManagerName,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
              const Text(
                'Required Advance',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  '${hostel.advanceAmount}',
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              const Text(
                'Return Amount',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  '${hostel.returnAmount}',
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              const Text(
                'Minimum Fee',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('DayWise',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text(hostel.dailyBasis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue))
                    ],
                  ),
                  Column(
                    children: [
                      const Text('MonthlyWise',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text(hostel.monthlyBasis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue))
                    ],
                  )
                ],
              ),
              const Text(
                'Facilities',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              if (hostel.facilities.isNotEmpty)
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: hostel.facilities.map((facility) {
                        return Text(
                          facility,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        );
                      }).toList(),
                    )),
              const Text(
                'images',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: hostel.hostelImages.map((image) {
                    return CachedNetworkImage(
                      fit: BoxFit.fitHeight,
                      imageUrl: image,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 70, width: 70, child: LoadingView()),
                      ),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
