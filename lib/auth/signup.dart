import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinguest/common/theme_helper.dart';
import 'package:payinguest/provider/maintainer.dart';
import 'package:payinguest/screens/GuestScreens/home.dart';
import 'package:payinguest/widgets/header_widget.dart';
import 'package:payinguest/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final bool asManager;
  static const routeName = 'Login';
  const SignUpPage({Key? key, required this.asManager}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final newMaintainer = Maintainer(
      maintainerId: '', name: '', phoneNumber: '', email: '', role: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                  child: HeaderWidget(
                    200,
                  ),
                ),
                SafeArea(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      margin: const EdgeInsets.fromLTRB(
                          20, 0, 20, 10), // This will be the login form
                      child: Column(
                        children: [
                          const Text(
                            'PAYINGUEST',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Create New Account',
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30.0),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    child: TextFormField(
                                      controller: nameController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Please enter Hostel ManagerName";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person),
                                        labelText: widget.asManager == true
                                            ? 'Manager Name'
                                            : 'Owner Name',
                                        hintText: widget.asManager == true
                                            ? 'Manager Name'
                                            : 'Owner Name',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
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
                                    child: TextFormField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.phone),
                                        labelText: 'Mobile Number',
                                        hintText: 'Phone No.',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
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
                                      textInputAction: TextInputAction.next,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.email),
                                        labelText: 'Email',
                                        hintText: 'Enter your Email address',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
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
                                  const SizedBox(height: 20.0),
                                  Container(
                                    child: TextFormField(
                                      obscureText: obscureText,
                                      controller: passwordController,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Please enter your password";
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: obscureText == true
                                              ? const Icon(Icons.visibility_off)
                                              : const Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                          },
                                        ),
                                        labelText: 'Password',
                                        hintText: 'Enter your password',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
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
                                  const SizedBox(height: 15.0),
                                  Container(
                                    decoration:
                                        ThemeHelper().buttonBoxDecoration(context),
                                    child: ElevatedButton(
                                      style: ThemeHelper().buttonStyle(),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 10, 40, 10),
                                        child: Text(
                                          'Create Account'.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                            newMaintainer.name =
                                                nameController.text;
                                            newMaintainer.phoneNumber =
                                                phoneController.text;
                                            newMaintainer.email =
                                                emailController.text;
                                            newMaintainer.role =
                                                widget.asManager == true
                                                    ? 'Manager'
                                                    : 'Owner';
                                          });
                                          try {
                                            Provider.of<MaintainerProvider>(context,
                                                    listen: false)
                                                .createAccount(
                                                    context,
                                                    newMaintainer,
                                                    passwordController.text)
                                                .then((value) {
                                              FirebaseAuth.instance.signOut();
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Verification Email has been Sent...'),
                                              backgroundColor: Colors.green,
                                            ));
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MyHomePage()),
                                                    (route) => false);
                                            setState(() {
                                              isLoading = false;
                                            });
                                          } on PlatformException catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(e.code),
                                              backgroundColor: Colors.orange,
                                            ));
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
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )),
                ),
              ],
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
