import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payinguest/provider/maintainer.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class MaintainerProfile extends StatefulWidget {
  final String maintainerId;
  static const routeName = 'Profile';
  const MaintainerProfile({Key? key, required this.maintainerId})
      : super(key: key);

  @override
  State<MaintainerProfile> createState() => _MaintainerProfileState();
}

class _MaintainerProfileState extends State<MaintainerProfile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
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

  updatePhoneNumber() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter New Number'),
            content: Form(
              key: formKey,
              child: TextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                controller: phoneNumber,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter the Phone Number";
                  }
                  if (value.length < 10) {
                    return "Please Check the Phone Number";
                  }
                  if (value.length > 10) {
                    return "Please Check the Phone Number";
                  }
                },
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Provider.of<MaintainerProvider>(context, listen: false)
                          .updatePhoneNumber(
                              context, widget.maintainerId, phoneNumber.text)
                          .then((value) {
                        setState(() {});
                      });
                      setState(() {
                        phoneNumber.clear();
                      });
                      Navigator.pop(context);
                    } else {
                      return;
                    }
                  },
                  child: const Text('Change'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffC8D9EB),
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Maintainers')
              .doc(widget.maintainerId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 150,
                  child: LoadingView(),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    snapshot.data!['role'] == 'Owner'
                        ? 'As Owner'
                        : 'As Manager',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoTitle('Name'),
                      infoDetail(context, snapshot.data!['name']),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('Email'),
                      infoDetail(context, snapshot.data!['email']),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      infoTitle('phone'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(snapshot.data!['phoneNumber'],
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {
                                updatePhoneNumber();
                              },
                              child: const Icon(Icons.edit))
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
