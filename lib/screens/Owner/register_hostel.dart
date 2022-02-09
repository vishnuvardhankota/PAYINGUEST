import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:payinguest/common/theme_helper.dart';
import 'package:payinguest/provider/hostel.dart';
import 'package:payinguest/widgets/header_widget.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:loading_indicator/loading_indicator.dart';

class RegistrationPage extends StatefulWidget {
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final String ownernumber;
  const RegistrationPage({
    Key? key,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownernumber,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey32 = GlobalKey<FormState>();
  bool isAdvanceRequired = false;
  bool isButtonActive = false;
  TextEditingController hostelNameController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaNameController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController dailyBasisController = TextEditingController();
  TextEditingController monthlyBasisController = TextEditingController();
  TextEditingController advanceAmountController = TextEditingController();
  TextEditingController returnAmountController = TextEditingController();
  late TextEditingController facilityController;
  FocusNode focusNode = FocusNode();
  bool isStep1 = true;
  bool isStep2 = false;
  bool isStep3 = false;
  bool isStep4 = false;
  bool isLoading = false;
  int? livingType = 0;
  File? mainImage;
  List<File> images = [];
  List<String> imagesUrl = [];
  List<String> facilities = [];

  @override
  void initState() {
    super.initState();
    Permission.camera.request();
    Permission.mediaLibrary.request();
    facilityController = TextEditingController();
    facilityController.addListener(() {
      final isButtonActive = facilityController.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  @override
  void dispose() {
    facilityController.dispose();
    super.dispose();
  }

  final newHostel = Hostel(
      hostelId: '',
      hostelOwnerId: '',
      hostelManagerId: '',
      hostelOwnerEmail: '',
      hostelImage: '',
      hostelName: '',
      livingType: 0,
      hostelOwnerName: '',
      hostelManagerName: '',
      hostelOwnerNumber: '',
      hostelPostalCode: '',
      hostelStreet: '',
      hostelMainArea: '',
      hostelCity: '',
      hostelState: '',
      dailyBasis: '',
      monthlyBasis: '',
      isAdvanceRequired: false,
      advanceAmount: 0,
      returnAmount: 0,
      hostelImages: [],
      facilities: [],
      isPremium: false,
      expiryDate: '');

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
  ImagePicker picker = ImagePicker();

  Future<File> compress(File image) async {
    File path = await FlutterNativeImage.compressImage(image.path,
        quality: 100, percentage: 40);
    return path;
  }

  step1() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Text('Step-1',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20.0),
          const Text(
            'Hostel Details',
            style: TextStyle(
                fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          if (mainImage != null)
            Container(
              height: 300,
              width: 300,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Image.file(
                mainImage!,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 5.0),
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
                                final capturedImage = await picker.pickImage(
                                    source: ImageSource.camera);
                                if (capturedImage == null) {
                                  return;
                                }
                                final compressedimage =
                                    await compress(File(capturedImage.path));
                                setState(() {
                                  mainImage = compressedimage;
                                });
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text('GALLERY'),
                              onTap: () async {
                                Navigator.pop(context);
                                final pickedImage = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedImage == null) {
                                  return;
                                }
                                final compressedimage =
                                    await compress(File(pickedImage.path));
                                setState(() {
                                  mainImage = compressedimage;
                                });
                              },
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.photo),
              label: Text(mainImage == null ? 'Add Hostel Photo' : 'Change')),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey1,
            child: Container(
              child: TextFormField(
                controller: hostelNameController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter Hostel Name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Hostal (or) PG Name',
                  hintText: 'Hostel Name',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
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
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                RadioListTile(
                    title: const Text('Boys'),
                    value: 0,
                    groupValue: livingType,
                    onChanged: (int? value) {
                      setState(() {
                        livingType = value;
                      });
                    }),
                RadioListTile(
                    title: const Text('Girls'),
                    value: 1,
                    groupValue: livingType,
                    onChanged: (int? value) {
                      setState(() {
                        livingType = value;
                      });
                    }),
                RadioListTile(
                    title: const Text('CO-Live'),
                    value: 2,
                    groupValue: livingType,
                    onChanged: (int? value) {
                      setState(() {
                        livingType = value;
                      });
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (mainImage == null &&
                        _formKey1.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Add Hostel Photo'),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    if (_formKey1.currentState!.validate()) {
                      setState(() {
                        isStep1 = false;
                        isStep2 = true;
                      });
                    }
                  },
                  child: const Text('Next')),
            ],
          )
        ],
      ),
    );
  }

  step2() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Text('Step-2',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey2,
            child: Column(
              children: [
                const Text(
                  'Hostel Address',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: postalCodeController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter Postal Code";
                            }

                            if (val.length != 6) {
                              return 'Code must be 6 digit';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Postal Code',
                            hintText: '6 digit number',
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0)),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0)),
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
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: areaNameController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter Area Name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Area Name',
                            hintText: 'Area Name',
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0)),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0)),
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
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  child: TextFormField(
                    controller: streetController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter Hostel street address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'street address',
                      hintText: 'Detail hostel address',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0)),
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: stateController,
                          decoration: InputDecoration(
                            labelText: 'State',
                            hintText: 'State Name',
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
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter CityName';
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
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isStep2 = false;
                      isStep1 = true;
                    });
                  },
                  child: const Text('Previous')),
              ElevatedButton(
                  onPressed: () {
                    if (selectedCity == null) {
                      return;
                    }
                    if (_formKey2.currentState!.validate()) {
                      setState(() {
                        isStep2 = false;
                        isStep3 = true;
                      });
                    }
                  },
                  child: const Text('Next')),
            ],
          )
        ],
      ),
    );
  }

  step3() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Text('Step-3',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40.0),
          Form(
            key: _formKey3,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    controller: dailyBasisController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter Daily Basis Amount";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Daily Basis Amount',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
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
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: monthlyBasisController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter Monthly Basis Amount";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Monthly Basis Amount',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
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
          ListTile(
            trailing: Checkbox(
                value: isAdvanceRequired,
                onChanged: (val) {
                  setState(() {
                    isAdvanceRequired = !isAdvanceRequired;
                  });
                }),
            title: const Text('Is Advance Required from Guest'),
          ),
          if (isAdvanceRequired)
            Form(
                key: _formKey32,
                child: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        controller: advanceAmountController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter Advance Amount";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Advance Amount',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0)),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0)),
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
                      height: 10,
                    ),
                    Container(
                      child: TextFormField(
                        controller: returnAmountController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter Return Amount";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Return Amount',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0)),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0)),
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
                )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isStep3 = false;
                      isStep2 = true;
                    });
                  },
                  child: const Text('Previous')),
              ElevatedButton(
                  onPressed: () {
                    if (isAdvanceRequired == true) {
                      if (_formKey3.currentState!.validate() &&
                          _formKey32.currentState!.validate()) {
                        setState(() {
                          isStep3 = false;
                          isStep4 = true;
                        });
                      }
                    } else if (_formKey3.currentState!.validate()) {
                      setState(() {
                        isStep3 = false;
                        isStep4 = true;
                      });
                    }
                  },
                  child: const Text('Next')),
            ],
          )
        ],
      ),
    );
  }

  step4() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Text('Step-4',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20.0),
          const Text(
            'Add Photos of Hostel Rooms',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
            children: images.map((image) {
              return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Image.file(
                  image,
                  fit: BoxFit.contain,
                ),
              );
            }).followedBy([
              if (images.length < 9)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: InkWell(
                    onTap: () {
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
                                      final compressedimage = await compress(
                                          File(capturedImage.path));
                                      setState(() {
                                        images.add(compressedimage);
                                      });
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo),
                                    title: const Text('GALLERY'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      final pickedImage =
                                          await picker.pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedImage == null) {
                                        return;
                                      }
                                      final compressedimage = await compress(
                                          File(pickedImage.path));
                                      setState(() {
                                        images.add(compressedimage);
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Image.asset(
                      'images/add.png',
                      color: Colors.blue,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
            ]).toList(),
          ),
          const Text(
            'Add Facilities of Hostel',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: facilities.map((facility) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      facility,
                      overflow: TextOverflow.fade,
                    ));
              }).followedBy([
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Flexible(
                          child: TextField(
                        decoration: const InputDecoration(
                            label: Text('Facility'),
                            labelStyle: TextStyle(fontSize: 22)),
                        controller: facilityController,
                      )),
                      ElevatedButton(
                          onPressed: isButtonActive
                              ? () {
                                  facilities.add(facilityController.text);
                                  setState(() {
                                    facilityController.clear();
                                    isButtonActive = false;
                                  });
                                }
                              : null,
                          child: const Text('Add'))
                    ],
                  ),
                )
              ]).toList()),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isStep4 = false;
                      isStep3 = true;
                    });
                  },
                  child: const Text('Previous')),
              Container(
                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                    style: ThemeHelper().buttonStyle(),
                    child: const Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    onPressed: registerHostel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> registerHostel() async {
    FocusScope.of(context).unfocus();
    final time = DateTime.now().toString();
    String expirydate = DateFormat.yMMMd()
        .add_jm()
        .format(DateTime.now().add(const Duration(days: 7)))
        .toString();
    setState(() {
      isLoading = true;
    });
    var imageFile = FirebaseStorage.instance
        .ref()
        .child('HostelMainPhotos')
        .child('${hostelNameController.text}.jpg');
    UploadTask task = imageFile.putFile(mainImage!);
    TaskSnapshot snapshot = await task;
    var imageUrl = await snapshot.ref.getDownloadURL();
    if (images.isNotEmpty) {
      int i = 1;
      for (var image in images) {
        setState(() {
          // ignore: unused_local_variable
          var value = i / images.length;
        });
        var imageFile = FirebaseStorage.instance
            .ref()
            .child('hostelImages')
            .child(hostelNameController.text)
            .child('${DateTime.now()}');
        UploadTask task = imageFile.putFile(image);
        TaskSnapshot snapshot = await task;
        await snapshot.ref.getDownloadURL().then((hostelimageUrl) {
          imagesUrl.add(hostelimageUrl);
          i++;
        });
      }
    }
    setState(() {
      newHostel.hostelId = time;
      newHostel.hostelOwnerId = widget.ownerId;
      newHostel.hostelManagerId = widget.ownerId;
      newHostel.hostelOwnerEmail = widget.ownerEmail;
      newHostel.hostelImage = imageUrl;
      newHostel.hostelName = hostelNameController.text;
      newHostel.livingType = livingType!;
      newHostel.hostelOwnerName = widget.ownerName;
      newHostel.hostelManagerName = widget.ownerName;
      newHostel.hostelOwnerNumber = widget.ownernumber;
      newHostel.hostelPostalCode = postalCodeController.text;
      newHostel.hostelMainArea = areaNameController.text;
      newHostel.hostelStreet = streetController.text;
      newHostel.hostelState = stateController.text;
      newHostel.hostelCity = selectedCity!;
      newHostel.dailyBasis = dailyBasisController.text;
      newHostel.monthlyBasis = monthlyBasisController.text;
      newHostel.isAdvanceRequired = isAdvanceRequired;
      newHostel.advanceAmount = isAdvanceRequired == true
          ? int.parse(advanceAmountController.text)
          : 0;
      newHostel.returnAmount = isAdvanceRequired == true
          ? int.parse(returnAmountController.text)
          : 0;
      newHostel.hostelImages = imagesUrl;
      newHostel.facilities = facilities;
      newHostel.isPremium = true;
      newHostel.expiryDate = expirydate;
    });
    try {
      Provider.of<HostelProvider>(context, listen: false)
          .addHostel(context, newHostel);
      Navigator.pop(context);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.code),
        backgroundColor: Colors.orange,
      ));
      return;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.code),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Stack(
              children: [
                const SizedBox(
                  height: 150,
                  child: HeaderWidget(
                    150,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 5, color: Colors.white),
                              color: Colors.blue,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.login_rounded,
                              color: Colors.grey.shade300,
                              size: 80.0,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          if (isStep1) step1(),
                          if (isStep2) step2(),
                          if (isStep3) step3(),
                          if (isStep4) step4(),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading == true)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: [
                          Colors.red,
                          Colors.orange,
                          Colors.yellow,
                          Colors.green,
                          Colors.indigo,
                          Colors.purple,
                        ],
                        strokeWidth: 2,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.transparent),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
