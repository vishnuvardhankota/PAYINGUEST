import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:payinguest/provider/guest.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ApplicationForm extends StatefulWidget {
  final String hostelId;
  const ApplicationForm({
    Key? key,
    required this.hostelId,
  }) : super(key: key);

  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController parentPhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController workingAddressController = TextEditingController();
  TextEditingController graduationController = TextEditingController();
  bool isLoading = false;
  File? passPhoto, aadharFront, aadharBack, idPhoto;
  String? idCardPhotoUrl;
  ImagePicker picker = ImagePicker();
  DateTime? dateofbirth, dateofjoining;
  String? dateOfBirth, dateOfJoining;
  late int d, m, y;
  String? totalDays, totalMonths, totalYears;
  int? gender = 0;
  int? stayingBase = 0;

  @override
  void initState() {
    Permission.camera.request();
    Permission.mediaLibrary.request();
    super.initState();
  }

  final newGuest = Guest(
      guestId: '',
      name: '',
      profile: '',
      gender: 0,
      age: '',
      guestDOB: '',
      phoneNum: '',
      parentPhoneNum: '',
      email: '',
      address: '',
      aadharFront: '',
      aadharBack: '',
      idCard: '',
      workingPlace: '',
      graduation: '',
      stayingBase: 0,
      rent: 0,
      guestDOJ: '',
      hostelId: '',
      ownerId: '',
      managerId: '',
      roomNum: 0);

  void dateOfBirthPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) {
          return CupertinoActionSheet(
            actions: [
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  initialDateTime: dateofbirth ?? DateTime.now(),
                  maximumYear: DateTime.now().year,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) {
                    setState(() {
                      dateofbirth = date;
                      dateOfBirth =
                          DateFormat().add_yMMMd().format(dateofbirth!);
                      d = date.day;
                      m = date.month;
                      y = date.year;
                      int d1 = DateTime.now().day;
                      int m1 = DateTime.now().month;
                      int y1 = DateTime.now().year;

                      int day = findDays(m1, y1);

                      if ((d1 - d) >= 0) {
                        totalDays = (d1 - d).toString();
                      } else {
                        totalDays = ((d1 + day) - d).toString();
                        m1 = m1 - 1;
                      }
                      if ((m1 - m) >= 0) {
                        totalMonths = (m1 - m).toString();
                      } else {
                        totalMonths = ((m1 + 12) - m).toString();
                        y1 = y1 - 1;
                      }
                      totalYears = (y1 - y).toString();
                    });
                  },
                ),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Done'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  int findDays(int m2, int y2) {
    int day2;
    if (m2 == 1 ||
        m2 == 3 ||
        m2 == 5 ||
        m2 == 7 ||
        m2 == 8 ||
        m2 == 10 ||
        m2 == 12) {
      day2 = 31;
    } else if (m2 == 4 || m2 == 6 || m2 == 9 || m2 == 11) {
      day2 = 30;
    } else {
      if (y2 % 4 == 0) {
        day2 = 29;
      } else {
        day2 = 28;
      }
    }
    return day2;
  }

  void dateOfJoiningPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) {
          return CupertinoActionSheet(
            actions: [
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  initialDateTime: dateofjoining ?? DateTime.now(),
                  maximumYear: DateTime.now().year + 1,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) {
                    setState(() {
                      dateofjoining = date;
                      dateOfJoining =
                          DateFormat().add_yMMMd().format(dateofjoining!);
                    });
                  },
                ),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Done'),
              onPressed: () {
                if (dateofjoining == null) {
                  setState(() {
                    dateofjoining = DateTime.now();
                    dateOfJoining =
                        DateFormat().add_yMMMd().format(DateTime.now());
                  });
                }
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final hostel =
        Provider.of<HostelProvider>(context).findById(widget.hostelId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Form'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Fill the Details',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 150,
                          child: passPhoto == null
                              ? Image.asset(
                                  'images/profile.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(passPhoto!, fit: BoxFit.cover),
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 120,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.camera),
                                            title: const Text('CAMERA'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              final capturedImage =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              if (capturedImage == null) {
                                                return;
                                              }
                                              File? croppedImage =
                                                  await ImageCropper.cropImage(
                                                      sourcePath: capturedImage
                                                          .path,
                                                      aspectRatioPresets: [
                                                        CropAspectRatioPreset
                                                            .square,
                                                      ],
                                                      androidUiSettings:
                                                          const AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Crop & Rotate',
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              toolbarColor:
                                                                  Colors.green,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .square,
                                                              lockAspectRatio:
                                                                  true));
                                              if (croppedImage != null) {
                                                setState(() {
                                                  passPhoto =
                                                      File(croppedImage.path);
                                                });
                                              }
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo),
                                            title: const Text('GALLERY'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              final pickedImage =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (pickedImage == null) {
                                                return;
                                              }
                                              File? croppedImage =
                                                  await ImageCropper.cropImage(
                                                      sourcePath: pickedImage
                                                          .path,
                                                      aspectRatioPresets: [
                                                        CropAspectRatioPreset
                                                            .square,
                                                      ],
                                                      androidUiSettings:
                                                          const AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Crop & Rotate',
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              toolbarColor:
                                                                  Colors.green,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .square,
                                                              lockAspectRatio:
                                                                  true));
                                              if (croppedImage != null) {
                                                setState(() {
                                                  passPhoto =
                                                      File(croppedImage.path);
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.photo),
                            label: Text(passPhoto == null
                                ? 'Add Photo'
                                : 'Change Photo'))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: formKey1,
                    child: Column(
                      children: [
                        Container(
                          child: TextFormField(
                            controller: fullNameController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter Your Name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Full Name',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                          ),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: RadioListTile(
                                    title: const Text('Male'),
                                    value: 0,
                                    groupValue: gender,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        gender = newValue;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile(
                                    title: const Text('Female'),
                                    value: 1,
                                    groupValue: gender,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        gender = newValue;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    totalYears == null
                                        ? 'Age -- '
                                        : 'Age  $totalYears ',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      dateOfBirth == null
                                          ? 'Date Of Birth'
                                          : dateOfBirth!,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    TextButton.icon(
                                      onPressed: dateOfBirthPicker,
                                      icon: const Icon(Icons.calendar_today),
                                      label: const Text('Pick Date'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Mobile Number',
                              hintText: 'Your Phone number',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter 10 digit Mobile Number';
                              }
                              if ((value.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(value)) {
                                return "Enter a valid phone number";
                              }
                              if (value.length < 10) {
                                return 'Mobile Number must be 10 digit';
                              }

                              return null;
                            },
                          ),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: parentPhoneController,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Parent Mobile Number',
                              hintText: 'Father Phone number',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter 10 digit Mobile Number';
                              }
                              if ((value.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(value)) {
                                return "Enter a valid phone number";
                              }
                              if (value.length < 10) {
                                return 'Mobile Number must be 10 digit';
                              }

                              return null;
                            },
                          ),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Email',
                              hintText: 'Enter your Email address',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your Email";
                              }
                              if ((val.isEmpty) &&
                                  RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            controller: homeAddressController,
                            textInputAction: TextInputAction.newline,
                            maxLines: 4,
                            keyboardType: TextInputType.streetAddress,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter Home Address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Home Address',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                          ),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: workingAddressController,
                            textInputAction: TextInputAction.newline,
                            maxLines: 4,
                            keyboardType: TextInputType.streetAddress,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter Working Place Address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Working Place Address',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                          ),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: graduationController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter Your Graduation";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Graduation',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                          ),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              RadioListTile(
                                  title: const Text('Monthly wise'),
                                  value: 0,
                                  groupValue: stayingBase,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      stayingBase = newValue;
                                    });
                                  }),
                              RadioListTile(
                                  title: const Text('Day wise'),
                                  value: 1,
                                  groupValue: stayingBase,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      stayingBase = newValue;
                                    });
                                  }),
                            ],
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          dateOfJoining == null
                              ? 'Date Of Joining'
                              : dateOfJoining!,
                          style: const TextStyle(fontSize: 17),
                        ),
                        TextButton.icon(
                          onPressed: dateOfJoiningPicker,
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Pick Date'),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: aadharFront == null
                            ? Image.asset(
                                'images/aadhar_front.jpg',
                                fit: BoxFit.fitWidth,
                              )
                            : Image.file(aadharFront!, fit: BoxFit.fitWidth),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera),
                                          title: const Text('CAMERA'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final capturedImage =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (capturedImage == null) {
                                              return;
                                            }
                                            File? croppedImage =
                                                await ImageCropper.cropImage(
                                                    sourcePath:
                                                        capturedImage.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .original,
                                                      CropAspectRatioPreset
                                                          .ratio16x9,
                                                      CropAspectRatioPreset
                                                          .ratio3x2,
                                                      CropAspectRatioPreset
                                                          .ratio4x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x4,
                                                      CropAspectRatioPreset
                                                          .ratio7x5,
                                                      CropAspectRatioPreset
                                                          .square,
                                                    ],
                                                    androidUiSettings:
                                                        const AndroidUiSettings(
                                                            toolbarTitle:
                                                                'Crop & Rotate',
                                                            toolbarWidgetColor:
                                                                Colors.white,
                                                            toolbarColor:
                                                                Colors.green,
                                                            initAspectRatio:
                                                                CropAspectRatioPreset
                                                                    .ratio16x9,
                                                            lockAspectRatio:
                                                                false));
                                            if (croppedImage != null) {
                                              setState(() {
                                                aadharFront =
                                                    File(croppedImage.path);
                                              });
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo),
                                          title: const Text('GALLERY'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final pickedImage =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (pickedImage == null) {
                                              return;
                                            }
                                            File? croppedImage =
                                                await ImageCropper.cropImage(
                                                    sourcePath:
                                                        pickedImage.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .original,
                                                      CropAspectRatioPreset
                                                          .ratio16x9,
                                                      CropAspectRatioPreset
                                                          .ratio3x2,
                                                      CropAspectRatioPreset
                                                          .ratio4x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x4,
                                                      CropAspectRatioPreset
                                                          .ratio7x5,
                                                      CropAspectRatioPreset
                                                          .square,
                                                    ],
                                                    androidUiSettings:
                                                        const AndroidUiSettings(
                                                            toolbarTitle:
                                                                'Crop & Rotate',
                                                            toolbarWidgetColor:
                                                                Colors.white,
                                                            toolbarColor:
                                                                Colors.green,
                                                            initAspectRatio:
                                                                CropAspectRatioPreset
                                                                    .ratio16x9,
                                                            lockAspectRatio:
                                                                false));
                                            if (croppedImage != null) {
                                              setState(() {
                                                aadharFront =
                                                    File(croppedImage.path);
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(Icons.photo),
                          label: Text(aadharFront == null
                              ? 'Add Aadhar Front Photo'
                              : 'Change Aadhar Front Photo')),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: aadharBack == null
                            ? Image.asset(
                                'images/aadhar_back.jpg',
                                fit: BoxFit.fitWidth,
                              )
                            : Image.file(aadharBack!, fit: BoxFit.fitWidth),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera),
                                          title: const Text('CAMERA'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final capturedImage =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (capturedImage == null) {
                                              return;
                                            }
                                            File? croppedImage =
                                                await ImageCropper.cropImage(
                                                    sourcePath:
                                                        capturedImage.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .original,
                                                      CropAspectRatioPreset
                                                          .ratio16x9,
                                                      CropAspectRatioPreset
                                                          .ratio3x2,
                                                      CropAspectRatioPreset
                                                          .ratio4x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x4,
                                                      CropAspectRatioPreset
                                                          .ratio7x5,
                                                      CropAspectRatioPreset
                                                          .square,
                                                    ],
                                                    androidUiSettings:
                                                        const AndroidUiSettings(
                                                            toolbarTitle:
                                                                'Crop & Rotate',
                                                            toolbarWidgetColor:
                                                                Colors.white,
                                                            toolbarColor:
                                                                Colors.green,
                                                            initAspectRatio:
                                                                CropAspectRatioPreset
                                                                    .ratio16x9,
                                                            lockAspectRatio:
                                                                false));
                                            if (croppedImage != null) {
                                              setState(() {
                                                aadharBack =
                                                    File(croppedImage.path);
                                              });
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo),
                                          title: const Text('GALLERY'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final pickedImage =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (pickedImage == null) {
                                              return;
                                            }
                                            File? croppedImage =
                                                await ImageCropper.cropImage(
                                                    sourcePath:
                                                        pickedImage.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .original,
                                                      CropAspectRatioPreset
                                                          .ratio16x9,
                                                      CropAspectRatioPreset
                                                          .ratio3x2,
                                                      CropAspectRatioPreset
                                                          .ratio4x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x3,
                                                      CropAspectRatioPreset
                                                          .ratio5x4,
                                                      CropAspectRatioPreset
                                                          .ratio7x5,
                                                      CropAspectRatioPreset
                                                          .square,
                                                    ],
                                                    androidUiSettings:
                                                        const AndroidUiSettings(
                                                            toolbarTitle:
                                                                'Crop & Rotate',
                                                            toolbarWidgetColor:
                                                                Colors.white,
                                                            toolbarColor:
                                                                Colors.green,
                                                            initAspectRatio:
                                                                CropAspectRatioPreset
                                                                    .ratio16x9,
                                                            lockAspectRatio:
                                                                false));
                                            if (croppedImage != null) {
                                              setState(() {
                                                aadharBack =
                                                    File(croppedImage.path);
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(Icons.photo),
                          label: Text(aadharBack == null
                              ? 'Add Aadhar Back Photo'
                              : 'Change Aadhar Back Photo')),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                      'Your Office (or) College (or) Institute Id card Photo (Optional)',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 150,
                          child: idPhoto == null
                              ? Image.asset(
                                  'images/id_card.jpg',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(idPhoto!, fit: BoxFit.cover),
                        ),
                        ElevatedButton.icon(
                            onPressed: () async {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 120,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.camera),
                                            title: const Text('CAMERA'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              final capturedImage =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              if (capturedImage == null) {
                                                return;
                                              }
                                              File? croppedImage =
                                                  await ImageCropper.cropImage(
                                                      sourcePath: capturedImage
                                                          .path,
                                                      aspectRatioPresets: [
                                                        CropAspectRatioPreset
                                                            .original,
                                                        CropAspectRatioPreset
                                                            .ratio16x9,
                                                        CropAspectRatioPreset
                                                            .ratio3x2,
                                                        CropAspectRatioPreset
                                                            .ratio4x3,
                                                        CropAspectRatioPreset
                                                            .ratio5x3,
                                                        CropAspectRatioPreset
                                                            .ratio5x4,
                                                        CropAspectRatioPreset
                                                            .ratio7x5,
                                                        CropAspectRatioPreset
                                                            .square,
                                                      ],
                                                      androidUiSettings:
                                                          const AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Crop & Rotate',
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              toolbarColor:
                                                                  Colors.green,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .original,
                                                              lockAspectRatio:
                                                                  false));
                                              if (croppedImage != null) {
                                                setState(() {
                                                  idPhoto =
                                                      File(croppedImage.path);
                                                });
                                              }
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo),
                                            title: const Text('GALLERY'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              final pickedImage =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (pickedImage == null) {
                                                return;
                                              }
                                              File? croppedImage =
                                                  await ImageCropper.cropImage(
                                                      sourcePath: pickedImage
                                                          .path,
                                                      aspectRatioPresets: [
                                                        CropAspectRatioPreset
                                                            .original,
                                                        CropAspectRatioPreset
                                                            .ratio16x9,
                                                        CropAspectRatioPreset
                                                            .ratio3x2,
                                                        CropAspectRatioPreset
                                                            .ratio4x3,
                                                        CropAspectRatioPreset
                                                            .ratio5x3,
                                                        CropAspectRatioPreset
                                                            .ratio5x4,
                                                        CropAspectRatioPreset
                                                            .ratio7x5,
                                                        CropAspectRatioPreset
                                                            .square,
                                                      ],
                                                      androidUiSettings:
                                                          const AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Crop & Rotate',
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              toolbarColor:
                                                                  Colors.green,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .original,
                                                              lockAspectRatio:
                                                                  false));
                                              if (croppedImage != null) {
                                                setState(() {
                                                  idPhoto =
                                                      File(croppedImage.path);
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.camera),
                            label: Text(
                                idPhoto == null ? 'Add Photo' : 'Change Photo'))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (hostel.isAdvanceRequired == true)
                    Column(
                      children: [
                        Text('Advance - ₹${hostel.advanceAmount}',
                            style: const TextStyle(fontSize: 25)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Return Amount ₹${hostel.returnAmount}',
                          overflow: TextOverflow.fade,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Note:- If you want to leave Pg/Hostel. You have to inform before 20 days. If you do not Inform Your Advance Amount and 20 days rental will not be Refund',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey1.currentState!.validate()) {
                          if (passPhoto == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Please Add PassPhoto')));
                            return;
                          }
                          if (dateOfBirth == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'Please select Date df Birth')));
                            return;
                          }
                          if (aadharFront == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content:
                                        Text('Please Add AadharPhoto')));
                            return;
                          }
                          if (aadharBack == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content:
                                        Text('Please Add AadharPhoto')));
                            return;
                          }
                          if (dateOfJoining == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'Please Select Date of Joining')));
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          final time = DateTime.now().toString();
                          var passPhotoFile = FirebaseStorage.instance
                              .ref()
                              .child('GeustProfilePhotos')
                              .child('${fullNameController.text}.jpg');
                          UploadTask task =
                              passPhotoFile.putFile(passPhoto!);
                          TaskSnapshot snapshot = await task;
                          String passPhotoUrl =
                              await snapshot.ref.getDownloadURL();

                          var aadharFrontFile = FirebaseStorage.instance
                              .ref()
                              .child('GuestAadharFrontPhotos')
                              .child('${fullNameController.text}.jpg');
                          UploadTask task2 =
                              aadharFrontFile.putFile(aadharFront!);
                          TaskSnapshot snapshot2 = await task2;
                          String aadharFrontPhotoUrl =
                              await snapshot2.ref.getDownloadURL();

                          var aadharBackFile = FirebaseStorage.instance
                              .ref()
                              .child('GuestAadharBackPhotos')
                              .child('${fullNameController.text}.jpg');
                          UploadTask task3 =
                              aadharBackFile.putFile(aadharBack!);
                          TaskSnapshot snapshot3 = await task3;
                          String aadharBackPhotoUrl =
                              await snapshot3.ref.getDownloadURL();

                          if (idPhoto != null) {
                            var idCardFile = FirebaseStorage.instance
                                .ref()
                                .child('GuestIdCardPhotos')
                                .child('${fullNameController.text}.jpg');
                            UploadTask task4 = idCardFile.putFile(idPhoto!);
                            TaskSnapshot snapshot4 = await task4;
                            final icpu =
                                await snapshot4.ref.getDownloadURL();
                            setState(() {
                              idCardPhotoUrl = icpu;
                            });
                          }
                          setState(() {
                            newGuest.guestId = time;
                            newGuest.name =
                                fullNameController.text;
                            newGuest.profile = passPhotoUrl;
                            newGuest.gender = gender!;
                            newGuest.age = totalYears.toString();
                            newGuest.guestDOB = dateOfBirth.toString();
                            newGuest.phoneNum =
                                phoneController.text;
                            newGuest.parentPhoneNum =
                                parentPhoneController.text;
                            newGuest.email =
                                emailController.text;
                            newGuest.address =
                                homeAddressController.text;
                            newGuest.aadharFront = aadharFrontPhotoUrl;
                            newGuest.aadharBack = aadharBackPhotoUrl;
                            newGuest.idCard = idCardPhotoUrl;
                            newGuest.workingPlace =
                                workingAddressController.text;
                            newGuest.graduation =
                                graduationController.text;
                            newGuest.stayingBase = stayingBase!;
                            newGuest.rent = 0;
                            newGuest.guestDOJ = dateOfJoining.toString();
                            newGuest.hostelId = widget.hostelId;
                            newGuest.ownerId = hostel.hostelOwnerId;
                            newGuest.managerId = hostel.hostelManagerId;
                            newGuest.roomNum = 0;
                          });
                          try {
                            Provider.of<GuestProvider>(context,
                                    listen: false)
                                .addGuest(
                              context,
                              newGuest,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Submit Successfully')));
                            Navigator.pop(context);
                            setState(() {
                              isLoading = false;
                            });
                          } on PlatformException catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('${err.message}')));
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          } on FirebaseFirestore catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('$error')));
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
            ),
          ),
          if (isLoading == true)
            Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: SizedBox(height: 100, child: LoadingView()))),
        ],
      ),
    );
  }
}
