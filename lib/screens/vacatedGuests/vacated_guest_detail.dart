import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/provider/vacatedguest.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import '../image_view.dart';

class VacatedGuestDetails extends StatelessWidget {
  final String vacatedGuestId;
  const VacatedGuestDetails({Key? key, required this.vacatedGuestId})
      : super(key: key);

  Widget infoTitle(String infoTitle) {
    return Text(infoTitle,
        style: const TextStyle(
            color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget infoDetail(BuildContext context, String infoDetail) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(infoDetail,
          textAlign: TextAlign.right,
          style: const TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final guest = Provider.of<VacatedGuestProvider>(context)
        .vacatedGuestById(vacatedGuestId);
    return Scaffold(
        backgroundColor: const Color(0xffC8D9EB),
        appBar: AppBar(
          title: const Text('Guest Profile'),
        ),
        body: Padding(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(65),
                            child: CachedNetworkImage(
                              width: 130,
                              height: 130,
                              imageUrl: guest.profile,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) =>
                                  const Center(child: LoadingView()),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
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
                infoTitle('Staying :- '),
                infoDetail(context,
                    guest.stayingBase == 0 ? 'Monthly wise' : 'Day wise'),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                infoTitle('Room No :- '),
                infoDetail(context, '${guest.roomNum}'),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                infoTitle('Rent :- '),
                infoDetail(context, '${guest.rent}'),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                infoTitle('Gender :- '),
                infoDetail(context, guest.gender == 0 ? 'Male' : 'Female'),
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
                infoTitle('Vacated on :- '),
                infoDetail(context, guest.guestDOV),
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
                              builder: (context) =>
                                  ImageView(imageUrl: guest.aadharFront)));
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
